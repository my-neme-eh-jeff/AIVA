//third party
import { redirect } from "@/app/navigation";

//components
import { getServerAuthSession } from "@/server/auth";
import Navbar from "./_components/Header";

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
      <Navbar />
      <main className="mr-40 mt-10">{children}</main>
    </>
  );
}
