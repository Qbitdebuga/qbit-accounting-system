import { Webhook } from 'svix';
import { headers } from 'next/headers';
import { WebhookEvent } from '@clerk/nextjs/server';
import { db } from '@qbit/database';
import { SystemRole } from '@qbit/auth';
import { clerkClient } from '@clerk/nextjs/server';

export async function POST(req: Request) {
  console.log("Clerk webhook received a request..."); // DEBUG: Log that the webhook was hit

  const WEBHOOK_SECRET = process.env.CLERK_WEBHOOK_SECRET;

  if (!WEBHOOK_SECRET) {
    console.error("CRITICAL: CLERK_WEBHOOK_SECRET is not set.");
    throw new Error('Please add CLERK_WEBHOOK_SECRET from Clerk Dashboard to .env or .env.local');
  }

  const headerPayload = await headers();
  const svix_id = headerPayload.get("svix-id");
  const svix_timestamp = headerPayload.get("svix-timestamp");
  const svix_signature = headerPayload.get("svix-signature");

  if (!svix_id || !svix_timestamp || !svix_signature) {
    console.error("Webhook failed: Missing Svix headers.");
    return new Response('Error occured -- no svix headers', { status: 400 });
  }

  const payload = await req.json();
  const body = JSON.stringify(payload);
  const wh = new Webhook(WEBHOOK_SECRET);
  let evt: WebhookEvent;

  try {
    evt = wh.verify(body, {
      "svix-id": svix_id,
      "svix-timestamp": svix_timestamp,
      "svix-signature": svix_signature,
    }) as WebhookEvent;
  } catch (err) {
    console.error('Error verifying webhook signature:', err);
    return new Response('Error occured', { status: 400 });
  }

  const eventType = evt.type;
  console.log(`Webhook event type: ${eventType}`);

  if (eventType === 'user.created') {
    const { id, email_addresses, first_name, last_name, image_url } = evt.data;
    const email = email_addresses[0]?.email_address;

    if (!email) {
      console.error("Webhook failed: New user has no email address.");
      return new Response('Error: No email address found for new user', { status: 400 });
    }
    
    try {
      console.log(`Processing new user: ${email} (Clerk ID: ${id})`);
      console.log("Attempting to connect to the database...");

      // This is a simple query to test the database connection before the transaction.
      await db.$connect();
      console.log("Database connection successful!");

      let userRole = SystemRole.EMPLOYEE;

      await db.$transaction(async (tx) => {
        console.log("Starting database transaction...");
        const newUser = await tx.user.create({
          data: {
            clerkId: id,
            email: email,
            firstName: first_name,
            lastName: last_name,
            avatarUrl: image_url,
          }
        });
        console.log(`User created in DB with ID: ${newUser.id}`);

        let company = await tx.company.findFirst();
        if (!company) {
          console.log("No company found, creating a new one...");
          company = await tx.company.create({
            data: { name: `${first_name}'s Company`, createdBy: newUser.id }
          });
          userRole = SystemRole.COMPANY_ADMIN;
          console.log(`New company created with ID: ${company.id}. User role set to ADMIN.`);
        }

        await tx.companyUser.create({
          data: { userId: newUser.id, companyId: company.id, role: userRole }
        });
        console.log(`User associated with company. Role: ${userRole}`);

        await (await clerkClient()).users.updateUser(id, {
          publicMetadata: { role: userRole }
        });
        console.log("Successfully updated Clerk user metadata.");
      });

      console.log("Transaction completed successfully.");

    } catch (dbError) {
      // This will now print the exact database error to your terminal.
      console.error('!!!!!!!!!! DATABASE ERROR !!!!!!!!!!!');
      console.error(dbError);
      console.error('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      return new Response('Error occured while writing to database', { status: 500 });
    } finally {
      await db.$disconnect();
      console.log("Database connection closed.");
    }
  }

  return new Response('', { status: 200 });
}
