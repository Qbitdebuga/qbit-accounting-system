/**
 * This layout component wraps the entire dashboard section of the application.
 * Authentication is handled by the middleware for all /dashboard routes.
 */
export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <>{children}</>;
}
