import { clerkMiddleware, createRouteMatcher } from '@clerk/nextjs/server';
import { NextResponse } from 'next/server';

// This function creates a matcher to easily check if a request is for a protected route.
const isProtectedRoute = createRouteMatcher([
  '/dashboard(.*)', // Protect all routes starting with /dashboard
]);

export default clerkMiddleware(async (auth, req) => {
  // If the route is protected, run Clerk's authentication check.
  // If the user is not logged in, this will automatically redirect them to the sign-in page.
  if (isProtectedRoute(req)) {
    await auth.protect();
    return NextResponse.next();
  }

  // Get the user ID from the auth object
  const { userId } = await auth();

  // If a user who is already logged in tries to visit the homepage,
  // we should redirect them to their dashboard.
  if (userId && req.nextUrl.pathname === '/') {
    const dashboardUrl = new URL('/dashboard', req.url);
    return NextResponse.redirect(dashboardUrl);
  }

  // For all other cases (e.g., a logged-out user visiting /sign-in), allow the request to proceed.
  return NextResponse.next();
});

export const config = {
  matcher: [
    // Skip Next.js internals and all static files, unless found in search params
    '/((?!_next|[^?]*\\.(?:html?|css|js(?!on)|jpe?g|webp|png|gif|svg|ttf|woff2?|ico|csv|docx?|xlsx?|zip|webmanifest)).*)',
    // Always run for API routes
    '/(api|trpc)(.*)',
  ],
};
