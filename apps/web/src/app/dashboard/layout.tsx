/**
 * This layout component wraps the entire dashboard section of the application.
 * Authentication is handled by the middleware for all /dashboard routes.
 */
import React from "react";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <>{children}</>;
}
