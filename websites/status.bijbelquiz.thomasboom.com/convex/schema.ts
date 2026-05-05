import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  events: defineTable({
    title: v.string(),
    description: v.string(),
    type: v.union(v.literal("incident"), v.literal("maintenance")),
    severity: v.union(v.literal("minor"), v.literal("major"), v.literal("critical")),
    status: v.union(v.literal("ongoing"), v.literal("resolved"), v.literal("scheduled")),
    impact: v.optional(v.union(v.literal("app"), v.literal("website"))),
    startsAt: v.number(),
    endsAt: v.optional(v.number()),
    createdAt: v.number()
  })
    .index("by_status", ["status"])
    .index("by_starts", ["startsAt"])
});
