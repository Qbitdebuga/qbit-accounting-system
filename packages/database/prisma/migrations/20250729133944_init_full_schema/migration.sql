/*
  Warnings:

  - The primary key for the `Company` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `Company` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - You are about to alter the column `name` on the `Company` table. The data in that column could be lost. The data in that column will be cast from `Text` to `VarChar(255)`.
  - The primary key for the `CompanyUser` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `createdById` on the `CompanyUser` table. All the data in the column will be lost.
  - The `id` column on the `CompanyUser` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - You are about to alter the column `role` on the `CompanyUser` table. The data in that column could be lost. The data in that column will be cast from `Text` to `VarChar(50)`.
  - The primary key for the `User` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `name` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `password` on the `User` table. All the data in the column will be lost.
  - The `id` column on the `User` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - You are about to alter the column `email` on the `User` table. The data in that column could be lost. The data in that column will be cast from `Text` to `VarChar(255)`.
  - A unique constraint covering the columns `[clerkId]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - Changed the type of `companyId` on the `CompanyUser` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `userId` on the `CompanyUser` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Added the required column `clerkId` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "public"."CompanyUser" DROP CONSTRAINT "CompanyUser_companyId_fkey";

-- DropForeignKey
ALTER TABLE "public"."CompanyUser" DROP CONSTRAINT "CompanyUser_createdById_fkey";

-- DropForeignKey
ALTER TABLE "public"."CompanyUser" DROP CONSTRAINT "CompanyUser_userId_fkey";

-- DropIndex
DROP INDEX "public"."CompanyUser_companyId_idx";

-- DropIndex
DROP INDEX "public"."CompanyUser_userId_idx";

-- AlterTable
ALTER TABLE "public"."Company" DROP CONSTRAINT "Company_pkey",
ADD COLUMN     "address" JSONB,
ADD COLUMN     "baseCurrency" VARCHAR(3) NOT NULL DEFAULT 'USD',
ADD COLUMN     "contactInfo" JSONB,
ADD COLUMN     "createdBy" UUID,
ADD COLUMN     "fiscalYearEnd" INTEGER NOT NULL DEFAULT 12,
ADD COLUMN     "industry" VARCHAR(100),
ADD COLUMN     "legalName" VARCHAR(255),
ADD COLUMN     "registrationNumber" VARCHAR(50),
ADD COLUMN     "settings" JSONB NOT NULL DEFAULT '{}',
ADD COLUMN     "subscriptionStatus" VARCHAR(20) NOT NULL DEFAULT 'active',
ADD COLUMN     "subscriptionTier" VARCHAR(50) NOT NULL DEFAULT 'basic',
ADD COLUMN     "taxId" VARCHAR(50),
ADD COLUMN     "updatedBy" UUID,
DROP COLUMN "id",
ADD COLUMN     "id" UUID NOT NULL DEFAULT gen_random_uuid(),
ALTER COLUMN "name" SET DATA TYPE VARCHAR(255),
ALTER COLUMN "updatedAt" SET DEFAULT CURRENT_TIMESTAMP,
ADD CONSTRAINT "Company_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "public"."CompanyUser" DROP CONSTRAINT "CompanyUser_pkey",
DROP COLUMN "createdById",
ADD COLUMN     "createdBy" UUID,
DROP COLUMN "id",
ADD COLUMN     "id" UUID NOT NULL DEFAULT gen_random_uuid(),
DROP COLUMN "companyId",
ADD COLUMN     "companyId" UUID NOT NULL,
DROP COLUMN "userId",
ADD COLUMN     "userId" UUID NOT NULL,
ALTER COLUMN "role" SET DATA TYPE VARCHAR(50),
ADD CONSTRAINT "CompanyUser_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "public"."User" DROP CONSTRAINT "User_pkey",
DROP COLUMN "name",
DROP COLUMN "password",
ADD COLUMN     "avatarUrl" TEXT,
ADD COLUMN     "clerkId" VARCHAR(255) NOT NULL,
ADD COLUMN     "firstName" VARCHAR(100),
ADD COLUMN     "language" VARCHAR(10) NOT NULL DEFAULT 'en',
ADD COLUMN     "lastLoginAt" TIMESTAMP,
ADD COLUMN     "lastName" VARCHAR(100),
ADD COLUMN     "phone" VARCHAR(20),
ADD COLUMN     "preferences" JSONB NOT NULL DEFAULT '{}',
ADD COLUMN     "timezone" VARCHAR(50) NOT NULL DEFAULT 'UTC',
DROP COLUMN "id",
ADD COLUMN     "id" UUID NOT NULL DEFAULT gen_random_uuid(),
ALTER COLUMN "email" SET DATA TYPE VARCHAR(255),
ALTER COLUMN "updatedAt" SET DEFAULT CURRENT_TIMESTAMP,
ADD CONSTRAINT "User_pkey" PRIMARY KEY ("id");

-- CreateTable
CREATE TABLE "public"."ChartOfAccounts" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    "code" VARCHAR(20) NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "accountType" VARCHAR(50) NOT NULL,
    "accountSubtype" VARCHAR(100),
    "parentId" UUID,
    "level" INTEGER NOT NULL DEFAULT 0,
    "path" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "isSystem" BOOLEAN NOT NULL DEFAULT false,
    "openingBalance" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "currentBalance" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "taxAccount" BOOLEAN NOT NULL DEFAULT false,
    "currency" VARCHAR(3) NOT NULL DEFAULT 'USD',
    "createdBy" UUID,
    "updatedBy" UUID,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ChartOfAccounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."GeneralLedgerEntry" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    "entryNumber" VARCHAR(50) NOT NULL,
    "entryDate" DATE NOT NULL,
    "postingDate" DATE NOT NULL,
    "periodYear" INTEGER NOT NULL,
    "periodMonth" INTEGER NOT NULL,
    "description" TEXT,
    "reference" VARCHAR(255),
    "sourceDocumentId" UUID,
    "sourceDocumentType" VARCHAR(50),
    "status" VARCHAR(20) NOT NULL DEFAULT 'draft',
    "totalDebit" DECIMAL(15,4) NOT NULL,
    "totalCredit" DECIMAL(15,4) NOT NULL,
    "currency" VARCHAR(3) NOT NULL DEFAULT 'USD',
    "exchangeRate" DECIMAL(10,6) NOT NULL DEFAULT 1.0,
    "isAdjustment" BOOLEAN NOT NULL DEFAULT false,
    "isRecurring" BOOLEAN NOT NULL DEFAULT false,
    "recurringPattern" JSONB,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdBy" UUID,
    "updatedBy" UUID,
    "postedBy" UUID,
    "postedAt" TIMESTAMP,

    CONSTRAINT "GeneralLedgerEntry_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."GeneralLedgerDetail" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "entryId" UUID NOT NULL,
    "lineNumber" INTEGER NOT NULL,
    "accountId" UUID NOT NULL,
    "debitAmount" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "creditAmount" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "debitAmountBase" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "creditAmountBase" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "description" TEXT,
    "dimension1" VARCHAR(100),
    "dimension2" VARCHAR(100),
    "dimension3" VARCHAR(100),
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "GeneralLedgerDetail_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Customer" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    "customerNumber" VARCHAR(50) NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "legalName" VARCHAR(255),
    "type" VARCHAR(20) NOT NULL DEFAULT 'individual',
    "taxId" VARCHAR(50),
    "paymentTerms" VARCHAR(50) NOT NULL DEFAULT 'net_30',
    "creditLimit" DECIMAL(15,2) NOT NULL DEFAULT 0,
    "currency" VARCHAR(3) NOT NULL DEFAULT 'USD',
    "priceLevel" VARCHAR(50) NOT NULL DEFAULT 'standard',
    "billingAddress" JSONB,
    "shippingAddress" JSONB,
    "contactInfo" JSONB,
    "bankDetails" JSONB,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdBy" UUID,
    "updatedBy" UUID,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Customer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Vendor" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    "vendorNumber" VARCHAR(50) NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "legalName" VARCHAR(255),
    "taxId" VARCHAR(50),
    "paymentTerms" VARCHAR(50) NOT NULL DEFAULT 'net_30',
    "currency" VARCHAR(3) NOT NULL DEFAULT 'USD',
    "address" JSONB,
    "contactInfo" JSONB,
    "bankDetails" JSONB,
    "is1099Vendor" BOOLEAN NOT NULL DEFAULT false,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdBy" UUID,
    "updatedBy" UUID,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Vendor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Product" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    "sku" VARCHAR(100) NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "category" VARCHAR(100),
    "type" VARCHAR(20) NOT NULL DEFAULT 'product',
    "unitOfMeasure" VARCHAR(20) NOT NULL DEFAULT 'each',
    "costPrice" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "sellingPrice" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "markupPercentage" DECIMAL(5,2) NOT NULL DEFAULT 0,
    "taxCategory" VARCHAR(50),
    "isTaxable" BOOLEAN NOT NULL DEFAULT true,
    "isInventoryTracked" BOOLEAN NOT NULL DEFAULT true,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "minimumStockLevel" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "reorderPoint" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "reorderQuantity" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "weight" DECIMAL(10,4),
    "dimensions" JSONB,
    "barcode" VARCHAR(100),
    "internalBarcode" VARCHAR(100),
    "attributes" JSONB NOT NULL DEFAULT '{}',
    "createdBy" UUID,
    "updatedBy" UUID,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ProductVariant" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "productId" UUID NOT NULL,
    "sku" VARCHAR(100) NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "attributes" JSONB NOT NULL,
    "costPrice" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "sellingPrice" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "barcode" VARCHAR(100),
    "internalBarcode" VARCHAR(100),
    "weight" DECIMAL(10,4),
    "dimensions" JSONB,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ProductVariant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Warehouse" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    "code" VARCHAR(20) NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "type" VARCHAR(50) NOT NULL DEFAULT 'standard',
    "address" JSONB,
    "contactInfo" JSONB,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "isDefault" BOOLEAN NOT NULL DEFAULT false,
    "createdBy" UUID,
    "updatedBy" UUID,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Warehouse_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Inventory" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    "productId" UUID,
    "variantId" UUID,
    "warehouseId" UUID NOT NULL,
    "quantityOnHand" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "quantityAvailable" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "quantityReserved" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "quantityOnOrder" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "averageCost" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "lastCost" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "binLocation" VARCHAR(50),
    "lastCountedAt" TIMESTAMP,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Inventory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."InventoryTransaction" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    "productId" UUID,
    "variantId" UUID,
    "warehouseId" UUID NOT NULL,
    "transactionType" VARCHAR(50) NOT NULL,
    "transactionDate" DATE NOT NULL,
    "referenceNumber" VARCHAR(100),
    "referenceType" VARCHAR(50),
    "referenceId" UUID,
    "quantityChange" DECIMAL(15,4) NOT NULL,
    "unitCost" DECIMAL(15,4),
    "totalCost" DECIMAL(15,4),
    "createdBy" UUID,
    "updatedBy" UUID,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "InventoryTransaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Invoice" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    "invoiceNumber" VARCHAR(50) NOT NULL,
    "customerId" UUID NOT NULL,
    "invoiceDate" DATE NOT NULL,
    "dueDate" DATE NOT NULL,
    "paymentTerms" VARCHAR(50),
    "currency" VARCHAR(3) NOT NULL DEFAULT 'USD',
    "exchangeRate" DECIMAL(10,6) NOT NULL DEFAULT 1.0,
    "subtotal" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "taxAmount" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "discountAmount" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "totalAmount" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "paidAmount" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "outstandingAmount" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "status" VARCHAR(20) NOT NULL DEFAULT 'draft',
    "billingAddress" JSONB,
    "shippingAddress" JSONB,
    "notes" TEXT,
    "terms" TEXT,
    "isRecurring" BOOLEAN NOT NULL DEFAULT false,
    "recurringPattern" JSONB,
    "nextInvoiceDate" DATE,
    "templateId" UUID,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdBy" UUID,
    "updatedBy" UUID,
    "sentAt" TIMESTAMP,

    CONSTRAINT "Invoice_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."InvoiceLineItem" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "invoiceId" UUID NOT NULL,
    "lineNumber" INTEGER NOT NULL,
    "productId" UUID,
    "variantId" UUID,
    "description" TEXT NOT NULL,
    "quantity" DECIMAL(15,4) NOT NULL DEFAULT 1,
    "unitPrice" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "discountPercentage" DECIMAL(5,2) NOT NULL DEFAULT 0,
    "discountAmount" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "lineTotal" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "taxRate" DECIMAL(5,4) NOT NULL DEFAULT 0,
    "taxAmount" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "accountId" UUID,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "InvoiceLineItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Bill" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    "billNumber" VARCHAR(50) NOT NULL,
    "vendorId" UUID NOT NULL,
    "billDate" DATE NOT NULL,
    "dueDate" DATE NOT NULL,
    "paymentTerms" VARCHAR(50),
    "currency" VARCHAR(3) NOT NULL DEFAULT 'USD',
    "exchangeRate" DECIMAL(10,6) NOT NULL DEFAULT 1.0,
    "subtotal" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "taxAmount" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "totalAmount" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "paidAmount" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "outstandingAmount" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "status" VARCHAR(20) NOT NULL DEFAULT 'draft',
    "referenceNumber" VARCHAR(100),
    "notes" TEXT,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedBy" UUID,
    "approvedAt" TIMESTAMP,

    CONSTRAINT "Bill_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."BillLineItem" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "billId" UUID NOT NULL,
    "lineNumber" INTEGER NOT NULL,
    "productId" UUID,
    "variantId" UUID,
    "description" TEXT NOT NULL,
    "quantity" DECIMAL(15,4) NOT NULL DEFAULT 1,
    "unitCost" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "lineTotal" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "taxRate" DECIMAL(5,4) NOT NULL DEFAULT 0,
    "taxAmount" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "accountId" UUID,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "BillLineItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Payment" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    "paymentNumber" VARCHAR(50) NOT NULL,
    "paymentType" VARCHAR(20) NOT NULL,
    "customerId" UUID,
    "vendorId" UUID,
    "paymentDate" DATE NOT NULL,
    "amount" DECIMAL(15,4) NOT NULL,
    "currency" VARCHAR(3) NOT NULL DEFAULT 'USD',
    "exchangeRate" DECIMAL(10,6) NOT NULL DEFAULT 1.0,
    "paymentMethod" VARCHAR(50) NOT NULL,
    "referenceNumber" VARCHAR(100),
    "bankAccountId" UUID,
    "notes" TEXT,
    "status" VARCHAR(20) NOT NULL DEFAULT 'cleared',
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdBy" UUID,
    "updatedBy" UUID,

    CONSTRAINT "Payment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."PaymentAllocation" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "paymentId" UUID NOT NULL,
    "invoiceId" UUID,
    "billId" UUID,
    "allocatedAmount" DECIMAL(15,4) NOT NULL,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PaymentAllocation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."FiscalPeriod" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    "periodName" VARCHAR(50) NOT NULL,
    "periodType" VARCHAR(20) NOT NULL,
    "startDate" DATE NOT NULL,
    "endDate" DATE NOT NULL,
    "fiscalYear" INTEGER NOT NULL,
    "periodNumber" INTEGER NOT NULL,
    "isClosed" BOOLEAN NOT NULL DEFAULT false,
    "closedAt" TIMESTAMP,
    "closedBy" UUID,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "FiscalPeriod_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Budget" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "budgetType" VARCHAR(50) NOT NULL,
    "fiscalYear" INTEGER NOT NULL,
    "startDate" DATE NOT NULL,
    "endDate" DATE NOT NULL,
    "status" VARCHAR(20) NOT NULL DEFAULT 'draft',
    "version" INTEGER NOT NULL DEFAULT 1,
    "parentBudgetId" UUID,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdBy" UUID,
    "updatedBy" UUID,
    "approvedAt" TIMESTAMP,

    CONSTRAINT "Budget_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."BudgetLineItem" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "budgetId" UUID NOT NULL,
    "accountId" UUID NOT NULL,
    "periodYear" INTEGER NOT NULL,
    "periodMonth" INTEGER NOT NULL,
    "budgetedAmount" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "actualAmount" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "dimension1" VARCHAR(100),
    "dimension2" VARCHAR(100),
    "dimension3" VARCHAR(100),
    "notes" TEXT,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "BudgetLineItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."EmployeeLeaveBalance" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "employeeId" UUID NOT NULL,
    "leaveType" VARCHAR(50) NOT NULL,
    "balanceHours" DECIMAL(6,2) NOT NULL DEFAULT 0,
    "accrualRate" DECIMAL(6,4),
    "maxBalance" DECIMAL(6,2),
    "year" INTEGER NOT NULL,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "EmployeeLeaveBalance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."TimeEntry" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    "employeeId" UUID NOT NULL,
    "entryDate" DATE NOT NULL,
    "clockIn" TIME,
    "clockOut" TIME,
    "breakDuration" interval DEFAULT '0 minutes'::interval,
    "overtimeHours" DECIMAL(8,2) NOT NULL DEFAULT 0,
    "entryType" VARCHAR(20) NOT NULL DEFAULT 'regular',
    "projectCode" VARCHAR(50),
    "notes" TEXT,
    "status" VARCHAR(20) NOT NULL DEFAULT 'draft',
    "submittedAt" TIMESTAMP,
    "approvedAt" TIMESTAMP,
    "approvedBy" UUID,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "TimeEntry_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."PayrollRun" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    "payPeriodStart" DATE NOT NULL,
    "payPeriodEnd" DATE NOT NULL,
    "payrollNumber" VARCHAR(50) NOT NULL,
    "payDate" DATE NOT NULL,
    "payrollType" VARCHAR(20) NOT NULL DEFAULT 'regular',
    "status" VARCHAR(20) NOT NULL DEFAULT 'draft',
    "totalGrossPay" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "totalDeductions" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "totalNetPay" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "totalEmployerTaxes" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "processedBy" UUID,
    "processedAt" TIMESTAMP,
    "notes" TEXT,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PayrollRun_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."BankAccount" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    "accountName" VARCHAR(255) NOT NULL,
    "accountNumber" VARCHAR(50) NOT NULL,
    "bankName" VARCHAR(255) NOT NULL,
    "bankIdentifier" VARCHAR(50),
    "accountType" VARCHAR(50) NOT NULL DEFAULT 'checking',
    "currency" VARCHAR(3) NOT NULL DEFAULT 'USD',
    "openingBalance" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "currentBalance" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "lastReconciledBalance" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "lastReconciledDate" DATE,
    "chartAccountId" UUID,
    "bankFeedEnabled" BOOLEAN NOT NULL DEFAULT false,
    "bankConnectionId" VARCHAR(255),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdBy" UUID,
    "updatedBy" UUID,

    CONSTRAINT "BankAccount_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."BankTransaction" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "bankAccountId" UUID NOT NULL,
    "transactionDate" DATE NOT NULL,
    "postedDate" DATE,
    "description" TEXT NOT NULL,
    "referenceNumber" VARCHAR(100),
    "transactionType" VARCHAR(20) NOT NULL,
    "amount" DECIMAL(15,4) NOT NULL,
    "runningBalance" DECIMAL(15,4),
    "bankCategory" VARCHAR(100),
    "isReconciled" BOOLEAN NOT NULL DEFAULT false,
    "reconciledAt" TIMESTAMP,
    "matchedPaymentId" UUID,
    "matchedJournalEntryId" UUID,
    "bankTransactionId" VARCHAR(255),
    "importedAt" TIMESTAMP,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "BankTransaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."BankReconciliation" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "bankAccountId" UUID NOT NULL,
    "reconciliationDate" DATE NOT NULL,
    "statementEndingDate" DATE NOT NULL,
    "statementEndingBalance" DECIMAL(15,4) NOT NULL,
    "bookBalance" DECIMAL(15,4) NOT NULL,
    "reconciledBalance" DECIMAL(15,4) NOT NULL,
    "outstandingDeposits" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "outstandingChecks" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "status" VARCHAR(20) NOT NULL DEFAULT 'in_progress',
    "notes" TEXT,
    "reconciledBy" UUID,
    "createdBy" UUID,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "BankReconciliation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."BankReconciliationItem" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "reconciliationId" UUID NOT NULL,
    "bankTransactionId" UUID,
    "generalLedgerEntryId" UUID,
    "paymentId" UUID,
    "itemType" VARCHAR(30) NOT NULL,
    "amount" DECIMAL(15,4) NOT NULL,
    "description" TEXT,
    "isMatched" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "BankReconciliationItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."BankFeed" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "bankAccountId" UUID NOT NULL,
    "provider" VARCHAR(50) NOT NULL,
    "connectionId" VARCHAR(255),
    "accessToken" TEXT,
    "refreshToken" TEXT,
    "lastSyncDate" TIMESTAMP,
    "syncFrequency" VARCHAR(20) NOT NULL DEFAULT 'daily',
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "errorCount" INTEGER NOT NULL DEFAULT 0,
    "lastError" TEXT,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "BankFeed_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Document" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "fileName" VARCHAR(500) NOT NULL,
    "fileSize" BIGINT NOT NULL,
    "fileType" VARCHAR(100) NOT NULL,
    "mimeType" VARCHAR(100),
    "filePath" VARCHAR(1000) NOT NULL,
    "fileHash" VARCHAR(64),
    "category" VARCHAR(100),
    "tags" TEXT[],
    "isProcessed" BOOLEAN NOT NULL DEFAULT false,
    "ocrText" TEXT,
    "ocrConfidence" DECIMAL(5,2),
    "metadata" JSONB,
    "retentionDate" DATE,
    "isArchived" BOOLEAN NOT NULL DEFAULT false,
    "createdBy" UUID,
    "updatedBy" UUID,

    CONSTRAINT "Document_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."DocumentAssociation" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "documentId" UUID NOT NULL,
    "entityType" VARCHAR(50) NOT NULL,
    "entityId" UUID NOT NULL,
    "associationType" VARCHAR(50) NOT NULL DEFAULT 'attachment',
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdBy" UUID,

    CONSTRAINT "DocumentAssociation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."DocumentVersion" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "documentId" UUID NOT NULL,
    "versionNumber" INTEGER NOT NULL,
    "fileName" VARCHAR(500) NOT NULL,
    "filePath" VARCHAR(1000) NOT NULL,
    "fileSize" BIGINT NOT NULL,
    "changeDescription" TEXT,
    "isCurrent" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdBy" UUID,

    CONSTRAINT "DocumentVersion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."AssetMaintenanceRecord" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "assetId" UUID NOT NULL,
    "maintenanceType" VARCHAR(50) NOT NULL,
    "description" TEXT NOT NULL,
    "maintenanceDate" DATE NOT NULL,
    "nextMaintenanceDate" DATE,
    "cost" DECIMAL(15,4) NOT NULL DEFAULT 0,
    "vendorId" UUID,
    "technicianName" VARCHAR(100),
    "warrantyExpiry" DATE,
    "notes" TEXT,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdBy" UUID,
    "updatedBy" UUID,

    CONSTRAINT "AssetMaintenanceRecord_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "GeneralLedgerEntry_companyId_idx" ON "public"."GeneralLedgerEntry"("companyId");

-- CreateIndex
CREATE INDEX "GeneralLedgerEntry_entryDate_idx" ON "public"."GeneralLedgerEntry"("entryDate");

-- CreateIndex
CREATE INDEX "GeneralLedgerEntry_periodYear_periodMonth_idx" ON "public"."GeneralLedgerEntry"("periodYear", "periodMonth");

-- CreateIndex
CREATE INDEX "GeneralLedgerEntry_status_idx" ON "public"."GeneralLedgerEntry"("status");

-- CreateIndex
CREATE UNIQUE INDEX "GeneralLedgerEntry_companyId_entryNumber_key" ON "public"."GeneralLedgerEntry"("companyId", "entryNumber");

-- CreateIndex
CREATE INDEX "GeneralLedgerDetail_entryId_idx" ON "public"."GeneralLedgerDetail"("entryId");

-- CreateIndex
CREATE INDEX "GeneralLedgerDetail_accountId_idx" ON "public"."GeneralLedgerDetail"("accountId");

-- CreateIndex
CREATE INDEX "GeneralLedgerDetail_dimension1_dimension2_dimension3_idx" ON "public"."GeneralLedgerDetail"("dimension1", "dimension2", "dimension3");

-- CreateIndex
CREATE INDEX "ProductVariant_productId_idx" ON "public"."ProductVariant"("productId");

-- CreateIndex
CREATE INDEX "ProductVariant_sku_idx" ON "public"."ProductVariant"("sku");

-- CreateIndex
CREATE INDEX "ProductVariant_barcode_idx" ON "public"."ProductVariant"("barcode");

-- CreateIndex
CREATE UNIQUE INDEX "ProductVariant_productId_sku_key" ON "public"."ProductVariant"("productId", "sku");

-- CreateIndex
CREATE INDEX "Inventory_companyId_idx" ON "public"."Inventory"("companyId");

-- CreateIndex
CREATE INDEX "Inventory_productId_idx" ON "public"."Inventory"("productId");

-- CreateIndex
CREATE INDEX "Inventory_variantId_idx" ON "public"."Inventory"("variantId");

-- CreateIndex
CREATE INDEX "Inventory_warehouseId_idx" ON "public"."Inventory"("warehouseId");

-- CreateIndex
CREATE UNIQUE INDEX "Inventory_productId_variantId_warehouseId_key" ON "public"."Inventory"("productId", "variantId", "warehouseId");

-- CreateIndex
CREATE INDEX "InventoryTransaction_companyId_idx" ON "public"."InventoryTransaction"("companyId");

-- CreateIndex
CREATE INDEX "InventoryTransaction_productId_idx" ON "public"."InventoryTransaction"("productId");

-- CreateIndex
CREATE INDEX "InventoryTransaction_variantId_idx" ON "public"."InventoryTransaction"("variantId");

-- CreateIndex
CREATE INDEX "InventoryTransaction_warehouseId_idx" ON "public"."InventoryTransaction"("warehouseId");

-- CreateIndex
CREATE INDEX "InventoryTransaction_transactionDate_idx" ON "public"."InventoryTransaction"("transactionDate");

-- CreateIndex
CREATE INDEX "InventoryTransaction_referenceType_referenceId_idx" ON "public"."InventoryTransaction"("referenceType", "referenceId");

-- CreateIndex
CREATE INDEX "Invoice_companyId_idx" ON "public"."Invoice"("companyId");

-- CreateIndex
CREATE INDEX "Invoice_customerId_idx" ON "public"."Invoice"("customerId");

-- CreateIndex
CREATE INDEX "Invoice_invoiceDate_idx" ON "public"."Invoice"("invoiceDate");

-- CreateIndex
CREATE INDEX "Invoice_dueDate_idx" ON "public"."Invoice"("dueDate");

-- CreateIndex
CREATE INDEX "Invoice_status_idx" ON "public"."Invoice"("status");

-- CreateIndex
CREATE INDEX "Invoice_invoiceNumber_idx" ON "public"."Invoice"("invoiceNumber");

-- CreateIndex
CREATE UNIQUE INDEX "Invoice_companyId_invoiceNumber_key" ON "public"."Invoice"("companyId", "invoiceNumber");

-- CreateIndex
CREATE INDEX "InvoiceLineItem_invoiceId_idx" ON "public"."InvoiceLineItem"("invoiceId");

-- CreateIndex
CREATE INDEX "InvoiceLineItem_productId_idx" ON "public"."InvoiceLineItem"("productId");

-- CreateIndex
CREATE INDEX "InvoiceLineItem_variantId_idx" ON "public"."InvoiceLineItem"("variantId");

-- CreateIndex
CREATE INDEX "Bill_companyId_idx" ON "public"."Bill"("companyId");

-- CreateIndex
CREATE INDEX "Bill_vendorId_idx" ON "public"."Bill"("vendorId");

-- CreateIndex
CREATE INDEX "Bill_billDate_idx" ON "public"."Bill"("billDate");

-- CreateIndex
CREATE INDEX "Bill_dueDate_idx" ON "public"."Bill"("dueDate");

-- CreateIndex
CREATE INDEX "Bill_status_idx" ON "public"."Bill"("status");

-- CreateIndex
CREATE UNIQUE INDEX "Bill_companyId_billNumber_key" ON "public"."Bill"("companyId", "billNumber");

-- CreateIndex
CREATE INDEX "BillLineItem_billId_idx" ON "public"."BillLineItem"("billId");

-- CreateIndex
CREATE INDEX "BillLineItem_productId_idx" ON "public"."BillLineItem"("productId");

-- CreateIndex
CREATE INDEX "BillLineItem_variantId_idx" ON "public"."BillLineItem"("variantId");

-- CreateIndex
CREATE INDEX "Payment_companyId_idx" ON "public"."Payment"("companyId");

-- CreateIndex
CREATE INDEX "Payment_customerId_idx" ON "public"."Payment"("customerId");

-- CreateIndex
CREATE INDEX "Payment_vendorId_idx" ON "public"."Payment"("vendorId");

-- CreateIndex
CREATE INDEX "Payment_paymentDate_idx" ON "public"."Payment"("paymentDate");

-- CreateIndex
CREATE INDEX "Payment_paymentType_idx" ON "public"."Payment"("paymentType");

-- CreateIndex
CREATE UNIQUE INDEX "Payment_companyId_paymentNumber_key" ON "public"."Payment"("companyId", "paymentNumber");

-- CreateIndex
CREATE INDEX "PaymentAllocation_paymentId_idx" ON "public"."PaymentAllocation"("paymentId");

-- CreateIndex
CREATE INDEX "PaymentAllocation_invoiceId_idx" ON "public"."PaymentAllocation"("invoiceId");

-- CreateIndex
CREATE INDEX "PaymentAllocation_billId_idx" ON "public"."PaymentAllocation"("billId");

-- CreateIndex
CREATE INDEX "FiscalPeriod_companyId_idx" ON "public"."FiscalPeriod"("companyId");

-- CreateIndex
CREATE INDEX "FiscalPeriod_startDate_endDate_idx" ON "public"."FiscalPeriod"("startDate", "endDate");

-- CreateIndex
CREATE INDEX "FiscalPeriod_fiscalYear_idx" ON "public"."FiscalPeriod"("fiscalYear");

-- CreateIndex
CREATE UNIQUE INDEX "FiscalPeriod_companyId_fiscalYear_periodNumber_periodType_key" ON "public"."FiscalPeriod"("companyId", "fiscalYear", "periodNumber", "periodType");

-- CreateIndex
CREATE INDEX "Budget_companyId_idx" ON "public"."Budget"("companyId");

-- CreateIndex
CREATE INDEX "Budget_fiscalYear_idx" ON "public"."Budget"("fiscalYear");

-- CreateIndex
CREATE INDEX "Budget_status_idx" ON "public"."Budget"("status");

-- CreateIndex
CREATE INDEX "BudgetLineItem_budgetId_idx" ON "public"."BudgetLineItem"("budgetId");

-- CreateIndex
CREATE INDEX "BudgetLineItem_accountId_idx" ON "public"."BudgetLineItem"("accountId");

-- CreateIndex
CREATE INDEX "BudgetLineItem_periodYear_periodMonth_idx" ON "public"."BudgetLineItem"("periodYear", "periodMonth");

-- CreateIndex
CREATE UNIQUE INDEX "BudgetLineItem_budgetId_accountId_periodYear_periodMonth_key" ON "public"."BudgetLineItem"("budgetId", "accountId", "periodYear", "periodMonth");

-- CreateIndex
CREATE INDEX "EmployeeLeaveBalance_employeeId_idx" ON "public"."EmployeeLeaveBalance"("employeeId");

-- CreateIndex
CREATE INDEX "EmployeeLeaveBalance_leaveType_idx" ON "public"."EmployeeLeaveBalance"("leaveType");

-- CreateIndex
CREATE UNIQUE INDEX "EmployeeLeaveBalance_employeeId_leaveType_year_key" ON "public"."EmployeeLeaveBalance"("employeeId", "leaveType", "year");

-- CreateIndex
CREATE INDEX "TimeEntry_companyId_idx" ON "public"."TimeEntry"("companyId");

-- CreateIndex
CREATE INDEX "TimeEntry_employeeId_idx" ON "public"."TimeEntry"("employeeId");

-- CreateIndex
CREATE INDEX "TimeEntry_entryDate_idx" ON "public"."TimeEntry"("entryDate");

-- CreateIndex
CREATE INDEX "TimeEntry_status_idx" ON "public"."TimeEntry"("status");

-- CreateIndex
CREATE INDEX "PayrollRun_companyId_idx" ON "public"."PayrollRun"("companyId");

-- CreateIndex
CREATE INDEX "PayrollRun_payPeriodStart_payPeriodEnd_idx" ON "public"."PayrollRun"("payPeriodStart", "payPeriodEnd");

-- CreateIndex
CREATE INDEX "PayrollRun_status_idx" ON "public"."PayrollRun"("status");

-- CreateIndex
CREATE UNIQUE INDEX "PayrollRun_companyId_payrollNumber_key" ON "public"."PayrollRun"("companyId", "payrollNumber");

-- CreateIndex
CREATE UNIQUE INDEX "PayrollRun_companyId_payPeriodStart_payPeriodEnd_payrollTyp_key" ON "public"."PayrollRun"("companyId", "payPeriodStart", "payPeriodEnd", "payrollType");

-- CreateIndex
CREATE INDEX "BankAccount_companyId_idx" ON "public"."BankAccount"("companyId");

-- CreateIndex
CREATE INDEX "BankAccount_chartAccountId_idx" ON "public"."BankAccount"("chartAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "BankAccount_companyId_accountNumber_bankIdentifier_key" ON "public"."BankAccount"("companyId", "accountNumber", "bankIdentifier");

-- CreateIndex
CREATE INDEX "BankTransaction_bankAccountId_idx" ON "public"."BankTransaction"("bankAccountId");

-- CreateIndex
CREATE INDEX "BankTransaction_transactionDate_idx" ON "public"."BankTransaction"("transactionDate");

-- CreateIndex
CREATE INDEX "BankTransaction_isReconciled_idx" ON "public"."BankTransaction"("isReconciled");

-- CreateIndex
CREATE INDEX "BankTransaction_bankTransactionId_idx" ON "public"."BankTransaction"("bankTransactionId");

-- CreateIndex
CREATE INDEX "BankReconciliation_bankAccountId_idx" ON "public"."BankReconciliation"("bankAccountId");

-- CreateIndex
CREATE INDEX "BankReconciliation_reconciliationDate_idx" ON "public"."BankReconciliation"("reconciliationDate");

-- CreateIndex
CREATE INDEX "BankReconciliation_status_idx" ON "public"."BankReconciliation"("status");

-- CreateIndex
CREATE UNIQUE INDEX "BankReconciliation_bankAccountId_statementEndingDate_key" ON "public"."BankReconciliation"("bankAccountId", "statementEndingDate");

-- CreateIndex
CREATE INDEX "BankReconciliationItem_reconciliationId_idx" ON "public"."BankReconciliationItem"("reconciliationId");

-- CreateIndex
CREATE INDEX "BankReconciliationItem_bankTransactionId_idx" ON "public"."BankReconciliationItem"("bankTransactionId");

-- CreateIndex
CREATE INDEX "BankReconciliationItem_itemType_idx" ON "public"."BankReconciliationItem"("itemType");

-- CreateIndex
CREATE INDEX "BankFeed_bankAccountId_idx" ON "public"."BankFeed"("bankAccountId");

-- CreateIndex
CREATE INDEX "BankFeed_provider_idx" ON "public"."BankFeed"("provider");

-- CreateIndex
CREATE INDEX "BankFeed_isActive_idx" ON "public"."BankFeed"("isActive");

-- CreateIndex
CREATE INDEX "AssetMaintenanceRecord_assetId_idx" ON "public"."AssetMaintenanceRecord"("assetId");

-- CreateIndex
CREATE INDEX "AssetMaintenanceRecord_maintenanceDate_idx" ON "public"."AssetMaintenanceRecord"("maintenanceDate");

-- CreateIndex
CREATE INDEX "AssetMaintenanceRecord_maintenanceType_idx" ON "public"."AssetMaintenanceRecord"("maintenanceType");

-- CreateIndex
CREATE UNIQUE INDEX "CompanyUser_companyId_userId_key" ON "public"."CompanyUser"("companyId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "User_clerkId_key" ON "public"."User"("clerkId");

-- AddForeignKey
ALTER TABLE "public"."Company" ADD CONSTRAINT "Company_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Company" ADD CONSTRAINT "Company_updatedBy_fkey" FOREIGN KEY ("updatedBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."CompanyUser" ADD CONSTRAINT "CompanyUser_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."CompanyUser" ADD CONSTRAINT "CompanyUser_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ChartOfAccounts" ADD CONSTRAINT "ChartOfAccounts_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ChartOfAccounts" ADD CONSTRAINT "ChartOfAccounts_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "public"."ChartOfAccounts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ChartOfAccounts" ADD CONSTRAINT "ChartOfAccounts_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ChartOfAccounts" ADD CONSTRAINT "ChartOfAccounts_updatedBy_fkey" FOREIGN KEY ("updatedBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."GeneralLedgerEntry" ADD CONSTRAINT "GeneralLedgerEntry_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."GeneralLedgerEntry" ADD CONSTRAINT "GeneralLedgerEntry_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."GeneralLedgerEntry" ADD CONSTRAINT "GeneralLedgerEntry_updatedBy_fkey" FOREIGN KEY ("updatedBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."GeneralLedgerEntry" ADD CONSTRAINT "GeneralLedgerEntry_postedBy_fkey" FOREIGN KEY ("postedBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."GeneralLedgerDetail" ADD CONSTRAINT "GeneralLedgerDetail_entryId_fkey" FOREIGN KEY ("entryId") REFERENCES "public"."GeneralLedgerEntry"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."GeneralLedgerDetail" ADD CONSTRAINT "GeneralLedgerDetail_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "public"."ChartOfAccounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Customer" ADD CONSTRAINT "Customer_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Customer" ADD CONSTRAINT "Customer_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Customer" ADD CONSTRAINT "Customer_updatedBy_fkey" FOREIGN KEY ("updatedBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Vendor" ADD CONSTRAINT "Vendor_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Vendor" ADD CONSTRAINT "Vendor_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Vendor" ADD CONSTRAINT "Vendor_updatedBy_fkey" FOREIGN KEY ("updatedBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Product" ADD CONSTRAINT "Product_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Product" ADD CONSTRAINT "Product_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Product" ADD CONSTRAINT "Product_updatedBy_fkey" FOREIGN KEY ("updatedBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ProductVariant" ADD CONSTRAINT "ProductVariant_productId_fkey" FOREIGN KEY ("productId") REFERENCES "public"."Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Warehouse" ADD CONSTRAINT "Warehouse_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Warehouse" ADD CONSTRAINT "Warehouse_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Warehouse" ADD CONSTRAINT "Warehouse_updatedBy_fkey" FOREIGN KEY ("updatedBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Inventory" ADD CONSTRAINT "Inventory_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Inventory" ADD CONSTRAINT "Inventory_productId_fkey" FOREIGN KEY ("productId") REFERENCES "public"."Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Inventory" ADD CONSTRAINT "Inventory_variantId_fkey" FOREIGN KEY ("variantId") REFERENCES "public"."ProductVariant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Inventory" ADD CONSTRAINT "Inventory_warehouseId_fkey" FOREIGN KEY ("warehouseId") REFERENCES "public"."Warehouse"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryTransaction" ADD CONSTRAINT "InventoryTransaction_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryTransaction" ADD CONSTRAINT "InventoryTransaction_productId_fkey" FOREIGN KEY ("productId") REFERENCES "public"."Product"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryTransaction" ADD CONSTRAINT "InventoryTransaction_variantId_fkey" FOREIGN KEY ("variantId") REFERENCES "public"."ProductVariant"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryTransaction" ADD CONSTRAINT "InventoryTransaction_warehouseId_fkey" FOREIGN KEY ("warehouseId") REFERENCES "public"."Warehouse"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryTransaction" ADD CONSTRAINT "InventoryTransaction_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryTransaction" ADD CONSTRAINT "InventoryTransaction_updatedBy_fkey" FOREIGN KEY ("updatedBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Invoice" ADD CONSTRAINT "Invoice_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Invoice" ADD CONSTRAINT "Invoice_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "public"."Customer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Invoice" ADD CONSTRAINT "Invoice_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Invoice" ADD CONSTRAINT "Invoice_updatedBy_fkey" FOREIGN KEY ("updatedBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InvoiceLineItem" ADD CONSTRAINT "InvoiceLineItem_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "public"."Invoice"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InvoiceLineItem" ADD CONSTRAINT "InvoiceLineItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "public"."Product"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InvoiceLineItem" ADD CONSTRAINT "InvoiceLineItem_variantId_fkey" FOREIGN KEY ("variantId") REFERENCES "public"."ProductVariant"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InvoiceLineItem" ADD CONSTRAINT "InvoiceLineItem_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "public"."ChartOfAccounts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Bill" ADD CONSTRAINT "Bill_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Bill" ADD CONSTRAINT "Bill_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "public"."Vendor"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Bill" ADD CONSTRAINT "Bill_updatedBy_fkey" FOREIGN KEY ("updatedBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BillLineItem" ADD CONSTRAINT "BillLineItem_billId_fkey" FOREIGN KEY ("billId") REFERENCES "public"."Bill"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BillLineItem" ADD CONSTRAINT "BillLineItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "public"."Product"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BillLineItem" ADD CONSTRAINT "BillLineItem_variantId_fkey" FOREIGN KEY ("variantId") REFERENCES "public"."ProductVariant"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BillLineItem" ADD CONSTRAINT "BillLineItem_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "public"."ChartOfAccounts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Payment" ADD CONSTRAINT "Payment_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Payment" ADD CONSTRAINT "Payment_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "public"."Customer"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Payment" ADD CONSTRAINT "Payment_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "public"."Vendor"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Payment" ADD CONSTRAINT "Payment_bankAccountId_fkey" FOREIGN KEY ("bankAccountId") REFERENCES "public"."BankAccount"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Payment" ADD CONSTRAINT "Payment_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Payment" ADD CONSTRAINT "Payment_updatedBy_fkey" FOREIGN KEY ("updatedBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PaymentAllocation" ADD CONSTRAINT "PaymentAllocation_paymentId_fkey" FOREIGN KEY ("paymentId") REFERENCES "public"."Payment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PaymentAllocation" ADD CONSTRAINT "PaymentAllocation_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "public"."Invoice"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PaymentAllocation" ADD CONSTRAINT "PaymentAllocation_billId_fkey" FOREIGN KEY ("billId") REFERENCES "public"."Bill"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."FiscalPeriod" ADD CONSTRAINT "FiscalPeriod_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Budget" ADD CONSTRAINT "Budget_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Budget" ADD CONSTRAINT "Budget_parentBudgetId_fkey" FOREIGN KEY ("parentBudgetId") REFERENCES "public"."Budget"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Budget" ADD CONSTRAINT "Budget_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Budget" ADD CONSTRAINT "Budget_updatedBy_fkey" FOREIGN KEY ("updatedBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BudgetLineItem" ADD CONSTRAINT "BudgetLineItem_budgetId_fkey" FOREIGN KEY ("budgetId") REFERENCES "public"."Budget"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BudgetLineItem" ADD CONSTRAINT "BudgetLineItem_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "public"."ChartOfAccounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."TimeEntry" ADD CONSTRAINT "TimeEntry_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PayrollRun" ADD CONSTRAINT "PayrollRun_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BankAccount" ADD CONSTRAINT "BankAccount_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BankAccount" ADD CONSTRAINT "BankAccount_chartAccountId_fkey" FOREIGN KEY ("chartAccountId") REFERENCES "public"."ChartOfAccounts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BankAccount" ADD CONSTRAINT "BankAccount_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BankAccount" ADD CONSTRAINT "BankAccount_updatedBy_fkey" FOREIGN KEY ("updatedBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BankTransaction" ADD CONSTRAINT "BankTransaction_bankAccountId_fkey" FOREIGN KEY ("bankAccountId") REFERENCES "public"."BankAccount"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BankTransaction" ADD CONSTRAINT "BankTransaction_matchedPaymentId_fkey" FOREIGN KEY ("matchedPaymentId") REFERENCES "public"."Payment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BankTransaction" ADD CONSTRAINT "BankTransaction_matchedJournalEntryId_fkey" FOREIGN KEY ("matchedJournalEntryId") REFERENCES "public"."GeneralLedgerEntry"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BankReconciliation" ADD CONSTRAINT "BankReconciliation_bankAccountId_fkey" FOREIGN KEY ("bankAccountId") REFERENCES "public"."BankAccount"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BankReconciliation" ADD CONSTRAINT "BankReconciliation_reconciledBy_fkey" FOREIGN KEY ("reconciledBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BankReconciliation" ADD CONSTRAINT "BankReconciliation_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BankReconciliationItem" ADD CONSTRAINT "BankReconciliationItem_reconciliationId_fkey" FOREIGN KEY ("reconciliationId") REFERENCES "public"."BankReconciliation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BankReconciliationItem" ADD CONSTRAINT "BankReconciliationItem_bankTransactionId_fkey" FOREIGN KEY ("bankTransactionId") REFERENCES "public"."BankTransaction"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BankReconciliationItem" ADD CONSTRAINT "BankReconciliationItem_generalLedgerEntryId_fkey" FOREIGN KEY ("generalLedgerEntryId") REFERENCES "public"."GeneralLedgerEntry"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BankReconciliationItem" ADD CONSTRAINT "BankReconciliationItem_paymentId_fkey" FOREIGN KEY ("paymentId") REFERENCES "public"."Payment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BankFeed" ADD CONSTRAINT "BankFeed_bankAccountId_fkey" FOREIGN KEY ("bankAccountId") REFERENCES "public"."BankAccount"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Document" ADD CONSTRAINT "Document_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Document" ADD CONSTRAINT "Document_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Document" ADD CONSTRAINT "Document_updatedBy_fkey" FOREIGN KEY ("updatedBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."DocumentAssociation" ADD CONSTRAINT "DocumentAssociation_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "public"."Document"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."DocumentAssociation" ADD CONSTRAINT "DocumentAssociation_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."DocumentVersion" ADD CONSTRAINT "DocumentVersion_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "public"."Document"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."DocumentVersion" ADD CONSTRAINT "DocumentVersion_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."AssetMaintenanceRecord" ADD CONSTRAINT "AssetMaintenanceRecord_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "public"."Vendor"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."AssetMaintenanceRecord" ADD CONSTRAINT "AssetMaintenanceRecord_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."AssetMaintenanceRecord" ADD CONSTRAINT "AssetMaintenanceRecord_updatedBy_fkey" FOREIGN KEY ("updatedBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
