import { ConvexHttpClient } from "convex/browser";
import { anyApi } from "convex/server";

const convexUrl =
  process.env.CONVEX_URL ?? process.env.NEXT_PUBLIC_CONVEX_URL;

export function getConvexClient() {
  if (!convexUrl) {
    throw new Error("CONVEX_URL is not set");
  }
  return new ConvexHttpClient(convexUrl);
}

export const api = anyApi;
