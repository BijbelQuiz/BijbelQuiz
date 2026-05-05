import { NextResponse } from "next/server";
import { getConvexClient, api } from "../../lib/convex";

export const dynamic = "force-dynamic";
export const revalidate = 0;

function statusCopy(status: "operational" | "degraded" | "major") {
  if (status === "major") {
    return {
      title: "Major Outage",
      summary: "We are actively fixing a critical service disruption."
    };
  }
  if (status === "degraded") {
    return {
      title: "Degraded Performance",
      summary: "Some services are slower than usual. Updates below."
    };
  }
  return {
    title: "All Systems Operational",
    summary: ""
  };
}

export async function GET() {
  const client = getConvexClient();
  const status = await client.query(api.events.getStatus, { windowDays: 90 });
  const copy = statusCopy(status.currentStatus);

  const payload = {
    status: status.currentStatus,
    title: copy.title,
    summary: copy.summary,
    updatedAt: new Date(status.lastUpdated).toISOString(),
    windowDays: status.windowDays,
    uptimePercent: Number(status.uptimePercent.toFixed(3)),
    events: status.events
      .filter((event: any) => event.status === "ongoing")
      .map((event: any) => ({
        id: event._id,
        title: event.title,
        description: event.description,
        type: event.type,
        severity: event.severity,
        status: event.status,
        impact: event.impact ?? "app",
        startsAt: new Date(event.startsAt).toISOString(),
        endsAt: event.endsAt ? new Date(event.endsAt).toISOString() : null
      }))
  };

  return NextResponse.json(payload, {
    headers: {
      "Cache-Control": "no-store"
    }
  });
}
