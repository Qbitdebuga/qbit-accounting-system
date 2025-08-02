'use client';

import { useAuth } from '@clerk/nextjs';
import { useRouter } from 'next/navigation';
import React, { useEffect } from 'react';

// A simple loading spinner component for a better user experience.
const LoadingSpinner = () => (
  <div className="flex justify-center items-center h-screen">
    <div className="animate-spin rounded-full h-32 w-32 border-t-2 border-b-2 border-gray-900"></div>
  </div>
);

/**
 * A component to protect routes that require authentication.
 * It checks if a user is authenticated and redirects to the sign-in page if not.
 * While checking, it displays a loading state.
 *
 * @param {object} props - The component props.
 * @param {React.ReactNode} props.children - The content to display if the user is authenticated.
 * @returns {React.ReactNode} The protected content or a loading spinner.
 */
export const ProtectedRoute = ({ children }: { children: React.ReactNode }) => {
  const { isLoaded, isSignedIn } = useAuth();
  const router = useRouter();

  useEffect(() => {
    // If the authentication state has loaded and the user is not signed in,
    // redirect them to the sign-in page.
    if (isLoaded && !isSignedIn) {
      router.push('/sign-in');
    }
  }, [isLoaded, isSignedIn, router]);

  // While Clerk is loading the authentication state, show a spinner.
  if (!isLoaded) {
    return <LoadingSpinner />;
  }
  
  // If the user is signed in, render the protected content.
  if (isSignedIn) {
    return <>{children}</>;
  }

  // If the user is not signed in (and the redirect is in progress), show a spinner.
  return <LoadingSpinner />;
};

// --- How to use this component ---
// In a page file like `apps/web/src/app/dashboard/layout.tsx`, you would do:
/*
import { ProtectedRoute } from '@qbit/auth'; // Adjust path if needed

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  return (
    <ProtectedRoute>
      {children}
    </ProtectedRoute>
  );
}
*/
