// Based on TECHNICAL_SPECIFICATION.md Section 8.1
export enum SystemRole {
    SUPER_ADMIN = 'super_admin',
    COMPANY_ADMIN = 'company_admin',
    MANAGER = 'manager',
    ACCOUNTANT = 'accountant',
    EMPLOYEE = 'employee',
    VIEWER = 'viewer',
  }
  
  export enum Permission {
  // Financial permissions
  VIEW_FINANCIALS = 'view_financials',
  EDIT_JOURNAL_ENTRIES = 'edit_journal_entries',
  APPROVE_TRANSACTIONS = 'approve_transactions',
  VIEW_REPORTS = 'view_reports',
  EXPORT_DATA = 'export_data',
  
  // Invoice permissions
  CREATE_INVOICES = 'create_invoices',
  EDIT_INVOICES = 'edit_invoices',
  DELETE_INVOICES = 'delete_invoices',
  VOID_INVOICES = 'void_invoices',
  
  // Inventory permissions
  VIEW_INVENTORY = 'view_inventory',
  ADJUST_INVENTORY = 'adjust_inventory',
  TRANSFER_INVENTORY = 'transfer_inventory',
  
  // User management
  MANAGE_USERS = 'manage_users',
  ASSIGN_ROLES = 'assign_roles',
  VIEW_AUDIT_LOG = 'view_audit_log',
  
  // Company management
  MANAGE_COMPANIES = 'manage_companies',
  VIEW_ALL_COMPANIES = 'view_all_companies',
  
  // System administration
  SYSTEM_CONFIG = 'system_config',
  BACKUP_RESTORE = 'backup_restore',
  INTEGRATION_CONFIG = 'integration_config',
  }
  
  // Role permission mapping based on TECHNICAL_SPECIFICATION.md Section 8.1
  export const rolePermissions: Record<SystemRole, Permission[]> = {
  [SystemRole.SUPER_ADMIN]: Object.values(Permission),
  [SystemRole.COMPANY_ADMIN]: [
  Permission.VIEW_FINANCIALS,
  Permission.EDIT_JOURNAL_ENTRIES,
  Permission.APPROVE_TRANSACTIONS,
  Permission.VIEW_REPORTS,
  Permission.EXPORT_DATA,
  Permission.CREATE_INVOICES,
  Permission.EDIT_INVOICES,
  Permission.DELETE_INVOICES,
  Permission.VIEW_INVENTORY,
  Permission.ADJUST_INVENTORY,
  Permission.TRANSFER_INVENTORY,
  Permission.MANAGE_USERS,
  Permission.ASSIGN_ROLES,
  Permission.VIEW_AUDIT_LOG,
  ],
  [SystemRole.MANAGER]: [
  Permission.VIEW_FINANCIALS,
  Permission.APPROVE_TRANSACTIONS,
  Permission.VIEW_REPORTS,
  Permission.EXPORT_DATA,
  Permission.CREATE_INVOICES,
  Permission.EDIT_INVOICES,
  Permission.VIEW_INVENTORY,
  Permission.ADJUST_INVENTORY,
  ],
  [SystemRole.ACCOUNTANT]: [
  Permission.VIEW_FINANCIALS,
  Permission.EDIT_JOURNAL_ENTRIES,
  Permission.VIEW_REPORTS,
  Permission.CREATE_INVOICES,
    Permission.EDIT_INVOICES,
  Permission.VIEW_INVENTORY,
  ],
  [SystemRole.EMPLOYEE]: [
  Permission.VIEW_FINANCIALS,
  Permission.VIEW_REPORTS,
  Permission.CREATE_INVOICES,
  Permission.VIEW_INVENTORY,
  ],
  [SystemRole.VIEWER]: [
  Permission.VIEW_FINANCIALS,
  Permission.VIEW_REPORTS,
  Permission.VIEW_INVENTORY,
  ],
  };