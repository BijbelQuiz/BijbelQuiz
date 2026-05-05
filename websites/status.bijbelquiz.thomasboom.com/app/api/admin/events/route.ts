import { NextResponse } from "next/server";
import { getConvexClient, api } from "../../../../lib/convex";

export const runtime = "nodejs";

function getAdminSecret() {
  const secret = process.env.CONVEX_ADMIN_SECRET;
  if (!secret) {
    throw new Error("CONVEX_ADMIN_SECRET is not configured");
  }
  return secret;
}

export async function GET() {
  try {
    const client = getConvexClient();
    const events = await client.query(api.events.adminListEvents, {});
    return NextResponse.json({ events });
  } catch (error) {
    return NextResponse.json({ error: "Failed to load events" }, { status: 500 });
  }
}

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const client = getConvexClient();
    const adminSecret = getAdminSecret();

    const id = await client.mutation(api.events.adminAddEvent, {
      adminSecret,
      title: body.title,
      description: body.description,
      type: body.type,
      severity: body.severity,
      status: body.status,
      impact: body.impact,
      startsAt: body.startsAt,
      endsAt: body.endsAt
    });

    return NextResponse.json({ id });
  } catch (error: any) {
    console.error("[status-admin] Failed to add event", {
      message: error?.message,
      stack: error?.stack
    });
    return NextResponse.json(
      { error: error?.message ?? "Failed to add event" },
      { status: 500 }
    );
  }
}

export async function PATCH(request: Request) {
  try {
    const body = await request.json();
    const client = getConvexClient();
    const adminSecret = getAdminSecret();

    if (body.action === "update") {
      await client.mutation(api.events.adminUpdateEvent, {
        adminSecret,
        id: body.id,
        title: body.title,
        description: body.description,
        type: body.type,
        severity: body.severity,
        status: body.status,
        impact: body.impact,
        startsAt: body.startsAt,
        endsAt: body.endsAt
      });
    } else {
      await client.mutation(api.events.adminResolveEvent, {
        adminSecret,
        id: body.id
      });
    }

    return NextResponse.json({ ok: true });
  } catch (error: any) {
    console.error("[status-admin] Failed to update/resolve event", {
      message: error?.message,
      stack: error?.stack
    });
    return NextResponse.json(
      { error: error?.message ?? "Failed to resolve event" },
      { status: 500 }
    );
  }
}
