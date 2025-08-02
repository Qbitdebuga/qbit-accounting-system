import AppLayout from '@web/components/layout/AppLayout';
//import { WithPermission, Permission } from '@qbit/auth';
import { Button } from '@web/components/ui/button';

export default function DashboardPage() {
  return (
    <AppLayout pageTitle="Dashboard">
      <div className="bg-white p-6 rounded-lg shadow-sm">
        <h2 className="text-2xl font-semibold text-gray-800 mb-4">
          Welcome to Qbit Accounting
        </h2>
        <p className="text-gray-600">
          This is your main dashboard. From here, you can navigate to all the
          core features of the system using the sidebar.
        </p>
        <Button>Test Button</Button>
      </div>
    </AppLayout>
  );
}