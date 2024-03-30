import Footer from "./_components/footer";
import Header from "./_components/header";

export default function HomeLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <>
      <Header />
      <main >{children}</main>
      <Footer />
    </>
  );
}
