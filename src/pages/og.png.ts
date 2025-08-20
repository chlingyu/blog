import type { APIRoute } from "astro";
import { generateOgImageForSite } from "@/utils/generateOgImages";

export const GET: APIRoute = async () => {
  const image = await generateOgImageForSite();
  return new Response(image as BodyInit, {
    headers: { "Content-Type": "image/png" },
  });
};
