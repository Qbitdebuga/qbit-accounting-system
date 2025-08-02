'use client';

import { useUser } from '@clerk/nextjs';
import { SystemRole, Permission, rolePermissions } from './permissions';

/**
 * A custom hook to check user permissions based on their role.
 * The role is read from the user's public metadata set by the webhook.
 * @returns An object with a function `hasPermission` to check for specific permissions.
 */
export const usePermissions = () => {
  const { user } = useUser();

  // Get the user's role from the public metadata.
  const role = user?.publicMetadata?.role as SystemRole;

  // Find the permissions associated with that role.
  const permissions = role ? rolePermissions[role] : [];

  /**
   * Checks if the current user has a specific permission.
   * @param {Permission} permission - The permission to check for.
   * @returns {boolean} - True if the user has the permission, false otherwise.
   */
  const hasPermission = (permission: Permission): boolean => {
    return permissions.includes(permission);
  };

  return { hasPermission, role };
};

interface WithPermissionProps {
  permission: Permission;
  children: React.ReactNode;
}

/**
 * A component that conditionally renders its children based on the user's permissions.
 * It uses the `usePermissions` hook to check if the user has the required permission.
 *
 * @param {WithPermissionProps} props - The component props.
 * @returns {React.ReactNode | null} - The children if the user has permission, otherwise null.
 */
export const WithPermission = ({ permission, children }: WithPermissionProps) => {
  const { hasPermission } = usePermissions();

  if (!hasPermission(permission)) {
    return null; // If the user doesn't have the permission, render nothing.
  }

  return <>{children}</>;
};
