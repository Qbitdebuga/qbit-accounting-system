import { PrismaClient } from '@prisma/client'

// This setup prevents multiple instances of Prisma Client from being created
// in the development environment due to Next.js's hot-reloading feature.
declare global {
  // allow global `var` declarations
   
  var prisma: PrismaClient | undefined
}

// Export a single, shared instance of the Prisma Client.
// This instance will be reused across the application.
export const db =
  global.prisma ||
  new PrismaClient({
    // Log database queries in development for easier debugging.
    log:
      process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
  })

if (process.env.NODE_ENV !== 'production') {
    global.prisma = db
}