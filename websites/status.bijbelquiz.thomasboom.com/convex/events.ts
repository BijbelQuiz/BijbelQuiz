import { queryGeneric as query, mutationGeneric as mutation } from "convex/server";
import { v } from "convex/values";

const ADMIN_SECRET_ENV = "CONVEX_ADMIN_SECRET";

const eventInput = {
  title: v.string(),
  description: v.string(),
  type: v.union(v.literal("incident"), v.literal("maintenance")),
  severity: v.union(v.literal("minor"), v.literal("major"), v.literal("critical")),
  status: v.union(v.literal("ongoing"), v.literal("resolved"), v.literal("scheduled")),
  impact: v.union(v.literal("app"), v.literal("website")),
  startsAt: v.number(),
  endsAt: v.optional(v.number())
};

export const listEvents = query({
  args: {},
  handler: async (ctx) => {
    const now = Date.now();
    const events = await ctx.db
      .query("events")
      .withIndex("by_starts")
      .order("desc")
      .take(50);
    return events.map((event) => ({
      ...event,
      impact: event.impact ?? "app",
      status: getEffectiveStatus(event, now)
    }));
  }
});

export const adminListEvents = query({
  args: {},
  handler: async (ctx) => {
    const events = await ctx.db
      .query("events")
      .withIndex("by_starts")
      .order("desc")
      .take(50);
    return events.map((event) => ({
      ...event,
      impact: event.impact ?? "app"
    }));
  }
});

export const getStatus = query({
  args: { windowDays: v.optional(v.number()) },
  handler: async (ctx, args) => {
    const windowDays = args.windowDays ?? 90;
    const now = Date.now();
    const windowMs = windowDays * 24 * 60 * 60 * 1000;
    const windowStart = now - windowMs;

    const events = await ctx.db
      .query("events")
      .withIndex("by_starts")
      .order("desc")
      .take(100);

    const normalizedEvents = events.map((event) => ({
      ...event,
      impact: event.impact ?? "app",
      status: getEffectiveStatus(event, now)
    }));

    const incidents = normalizedEvents.filter(
      (event) => event.type === "incident"
    );

    let downtimeMs = 0;
    for (const event of incidents) {
      const eventStart = event.startsAt;
      const eventEnd = event.endsAt ?? now;
      const overlapStart = Math.max(eventStart, windowStart);
      const overlapEnd = Math.min(eventEnd, now);
      if (overlapEnd > overlapStart) {
        downtimeMs += overlapEnd - overlapStart;
      }
    }

    const uptimePercent = Math.max(
      0,
      Math.min(100, 100 - (downtimeMs / windowMs) * 100)
    );

    const ongoingIncidents = incidents.filter(
      (event) => event.status === "ongoing"
    );

    let currentStatus: "operational" | "degraded" | "major" = "operational";
    if (ongoingIncidents.some((event) => event.severity === "critical")) {
      currentStatus = "major";
    } else if (ongoingIncidents.length > 0) {
      currentStatus = "degraded";
    }

    return {
      uptimePercent,
      currentStatus,
      windowDays,
      lastUpdated: now,
      events: normalizedEvents.slice(0, 12)
    };
  }
});

function getEffectiveStatus(
  event: {
    status: "ongoing" | "resolved" | "scheduled";
    startsAt: number;
    endsAt?: number;
  },
  now: number
): "ongoing" | "resolved" | "scheduled" {
  if (event.status === "resolved") {
    return "resolved";
  }
  if (event.endsAt && event.endsAt <= now) {
    return "resolved";
  }
  if (event.startsAt > now) {
    return "scheduled";
  }
  return "ongoing";
}

export const adminAddEvent = mutation({
  args: {
    adminSecret: v.string(),
    ...eventInput
  },
  handler: async (ctx, args) => {
    const expectedSecret = process.env[ADMIN_SECRET_ENV];
    if (!expectedSecret || args.adminSecret !== expectedSecret) {
      console.warn("[status-admin] Unauthorized adminAddEvent", {
        hasExpectedSecret: Boolean(expectedSecret),
        hasProvidedSecret: Boolean(args.adminSecret)
      });
      throw new Error("Unauthorized");
    }

    if (args.endsAt && args.endsAt < args.startsAt) {
      throw new Error("End time cannot be before start time");
    }

    return await ctx.db.insert("events", {
      title: args.title,
      description: args.description,
      type: args.type,
      severity: args.severity,
      status: args.status,
      impact: args.impact,
      startsAt: args.startsAt,
      endsAt: args.endsAt,
      createdAt: Date.now()
    });
  }
});

export const adminResolveEvent = mutation({
  args: {
    adminSecret: v.string(),
    id: v.id("events"),
    endsAt: v.optional(v.number()),
    status: v.optional(v.union(v.literal("resolved"), v.literal("scheduled")))
  },
  handler: async (ctx, args) => {
    const expectedSecret = process.env[ADMIN_SECRET_ENV];
    if (!expectedSecret || args.adminSecret !== expectedSecret) {
      console.warn("[status-admin] Unauthorized adminResolveEvent", {
        hasExpectedSecret: Boolean(expectedSecret),
        hasProvidedSecret: Boolean(args.adminSecret)
      });
      throw new Error("Unauthorized");
    }

    const event = await ctx.db.get(args.id);
    if (!event) {
      throw new Error("Event not found");
    }

    const endsAt = args.endsAt ?? Date.now();

    await ctx.db.patch(args.id, {
      endsAt,
      status: args.status ?? "resolved"
    });

    return true;
  }
});

export const adminUpdateEvent = mutation({
  args: {
    adminSecret: v.string(),
    id: v.id("events"),
    title: v.optional(v.string()),
    description: v.optional(v.string()),
    type: v.optional(v.union(v.literal("incident"), v.literal("maintenance"))),
    severity: v.optional(v.union(v.literal("minor"), v.literal("major"), v.literal("critical"))),
    status: v.optional(v.union(v.literal("ongoing"), v.literal("resolved"), v.literal("scheduled"))),
    impact: v.optional(v.union(v.literal("app"), v.literal("website"))),
    startsAt: v.optional(v.number()),
    endsAt: v.optional(v.number())
  },
  handler: async (ctx, args) => {
    const expectedSecret = process.env[ADMIN_SECRET_ENV];
    if (!expectedSecret || args.adminSecret !== expectedSecret) {
      console.warn("[status-admin] Unauthorized adminUpdateEvent", {
        hasExpectedSecret: Boolean(expectedSecret),
        hasProvidedSecret: Boolean(args.adminSecret)
      });
      throw new Error("Unauthorized");
    }

    const event = await ctx.db.get(args.id);
    if (!event) {
      throw new Error("Event not found");
    }

    const nextStartsAt = args.startsAt ?? event.startsAt;
    const nextEndsAt = args.endsAt ?? event.endsAt;

    if (nextEndsAt && nextEndsAt < nextStartsAt) {
      throw new Error("End time cannot be before start time");
    }

    await ctx.db.patch(args.id, {
      title: args.title ?? event.title,
      description: args.description ?? event.description,
      type: args.type ?? event.type,
      severity: args.severity ?? event.severity,
      status: args.status ?? event.status,
      impact: args.impact ?? event.impact,
      startsAt: args.startsAt ?? event.startsAt,
      endsAt: args.endsAt ?? event.endsAt
    });

    return true;
  }
});
