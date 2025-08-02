'use client';

import React, { useState } from 'react';
import { UserButton, SignedIn } from '@clerk/nextjs';
import Link from 'next/link';
import { cn } from '@web/lib/utils'; // This utility is from shadcn/ui
import { Button } from '@web/components/ui/button'; // The button we just added

// --- Helper Components ---

// An Icon component using SVG for better performance and scalability.
// In a real app, you might use a library like lucide-react.
const Icon = ({ name, className }: { name: string; className?: string }) => {
  const icons: { [key: string]: React.ReactNode } = {
    dashboard: <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><rect width="7" height="9" x="3" y="3" rx="1"/><rect width="7"height="5" x="14" y="3" rx="1"/><rect width="7" height="9" x="14" y="12" rx="1"/><rect width="7" height="5" x="3" y="16" rx="1"/></svg>,
    accounting: <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>,
    receivables: <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>,
    payables: <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M2 12h20"/><path d="M12 2a10 10 0 0 0-10 10v1a10 10 0 0 0 10 10h1a10 10 0 0 0 10-10v-1a10 10 0 0 0-10-10h-1Z"/></svg>,
    inventory: <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg>,
    menu: <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="4" x2="20" y1="12" y2="12"/><line x1="4" x2="20" y1="6" y2="6"/><line x1="4" x2="20" y1="18" y2="18"/></svg>,
  };
  return <div className={className}>{icons[name]}</div>;
};

// --- Main Components ---

const NavigationSidebar = ({ className }: { className?: string }) => {
  const navItems = [
    { name: 'Dashboard', icon: 'dashboard', href: '/dashboard' },
    { name: 'Accounting', icon: 'accounting', href: '/dashboard/accounting' },
    { name: 'Receivables', icon: 'receivables', href: '/dashboard/receivables' },
    { name: 'Payables', icon: 'payables', href: '/dashboard/payables' },
    { name: 'Inventory', icon: 'inventory', href: '/dashboard/inventory' },
  ];

  return (
    <aside className={cn("w-64 flex-shrink-0 bg-gray-900 text-gray-200 p-4 flex flex-col", className)}>
      <div className="text-white font-bold text-2xl mb-10 px-2">Qbit</div>
      <nav className="flex flex-col space-y-1">
        {navItems.map((item) => (
          <Link key={item.name} href={item.href} passHref>
            <Button
              variant="ghost"
              className="w-full justify-start text-left text-gray-300 hover:bg-gray-700 hover:text-white"
            >
              <Icon name={item.icon} className="h-5 w-5 mr-3" />
              <span>{item.name}</span>
            </Button>
          </Link>
        ))}
      </nav>
    </aside>
  );
};

const DashboardHeader = ({ title, onMenuClick }: { title: string; onMenuClick: () => void; }) => {
  return (
    <header className="bg-white border-b border-gray-200 p-4 flex justify-between items-center h-16 flex-shrink-0">
      <div className="flex items-center">
        <Button onClick={onMenuClick} variant="ghost" size="icon" className="md:hidden mr-2">
            <Icon name="menu" className="h-6 w-6" />
        </Button>
        <h1 className="text-xl font-semibold text-gray-800">{title}</h1>
      </div>
      <SignedIn>
        <UserButton afterSignOutUrl="/" />
      </SignedIn>
    </header>
  );
};

export default function AppLayout({ children, pageTitle = 'Dashboard' }: { children: React.ReactNode; pageTitle: string; }) {
  const [isSidebarOpen, setSidebarOpen] = useState(false);

  return (
    <div className="flex h-screen bg-gray-50 font-sans">
      {/* Desktop Sidebar */}
      <div className="hidden md:flex">
        <NavigationSidebar />
      </div>

      {/* Mobile Sidebar (overlay) */}
      {isSidebarOpen && (
        <div className="fixed inset-0 z-30 md:hidden">
            <div className="absolute inset-0 bg-black opacity-50" onClick={() => setSidebarOpen(false)}></div>
            <div className="relative z-40">
                <NavigationSidebar />
            </div>
        </div>
      )}

      <div className="flex-1 flex flex-col overflow-hidden">
        <DashboardHeader title={pageTitle} onMenuClick={() => setSidebarOpen(!isSidebarOpen)} />
        <main className="flex-1 overflow-x-hidden overflow-y-auto p-4 md:p-6 lg:p-8">
          {children}
        </main>
      </div>
    </div>
  );
}
