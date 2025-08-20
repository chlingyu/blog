// Helper function to get the correct base path for links
export function getBasePath(path: string = ""): string {
  const base = import.meta.env.BASE_URL || "/";
  // Remove leading slash from path if it exists
  const cleanPath = path.startsWith("/") ? path.slice(1) : path;
  // Ensure base ends with slash
  const cleanBase = base.endsWith("/") ? base : base + "/";
  return cleanBase + cleanPath;
}