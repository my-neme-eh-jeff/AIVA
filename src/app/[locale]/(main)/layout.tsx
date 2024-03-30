//third party
import { redirect } from "@/app/navigation";

//components
import { getServerAuthSession } from "@/server/auth";
import Index from "./_components/Header";

export default async function MainLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const session = await getServerAuthSession();
  // if (!session) {
  //   redirect("/login");
  // }
  return (
    <>
      <Index />
      <main>{children}</main>
    </>
  );
}
