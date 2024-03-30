import FAQSection from "./_components/faq-section";
import FeatureGlobeSection from "./_components/feature-globe-section";
import HeroSection from "./_components/hero-section/page";
import PhoneSection from "./_components/phone-section";
import PricingSection from "./_components/pricing-section";

export default async function Home() {
  return (
    <>
      <div className="h-screen place-content-center" id="hero">
        <HeroSection />
      </div>
      <div>
        <FeatureGlobeSection />
      </div>
      <div>
        <PhoneSection />
      </div>
      <div className="mt-2">
        <FAQSection />
      </div>
      <div className="mb-48">
        <PricingSection />
      </div>
    </>
  );
}
