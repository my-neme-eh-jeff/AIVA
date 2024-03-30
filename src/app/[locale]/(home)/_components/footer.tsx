//third party
import {
  Instagram,
  Twitter,
  Bot,
  Scale,
  BarChart3,
  Home,
} from "lucide-react";
import { Link } from "@nextui-org/link";
import { Divider } from "@nextui-org/divider";
import { siteConfig } from "siteConfig";

//components

export default function Footer() {
  const developers = [
    {
      name: "Aman Nambisan",
      linkedin: "https://www.linkedin.com/in/amannambisan/",
    },
    {
      name: "Mann Bhanushali",
      linkedin: "https://www.linkedin.com/in/innomer",
    },
    {
      name: "Varun Vishwanath",
      linkedin: "https://www.linkedin.com/in/varun-viswanath-10a3b0222/",
    },
    {
      name: "Paarshva Chitaliya",
      linkedin: "https://www.linkedin.com/in/paarshva-chitaliya",
    },
  ];
  const pagesForFooter = [
    {
      title: "Dashboard",
      description: "Calculate your retirement corpus",
      icon: <Home />,
      href: "/retirement-calculator",
    },
    {
      title: "Chatbot",
      description: "Get financial advice from our chatbot",
      icon: <Bot />,
      href: "/chatbot",
    },
    {
      title: "Analytics",
      description:
        "Get insights about how our AI models helped grow various companies",
      icon: <BarChart3 />,
      href: "/analytics",
    },
  ] as const;

  return (
    <footer className="bottom-0 w-full">
      <div className="relative mt-16 bg-[#797b47] dark:bg-[#292a17]">
        <svg
          className="absolute top-0 -mt-5 h-6 w-full text-[#797b47] dark:text-[#292a17] sm:-mt-10 sm:h-16"
          preserveAspectRatio="none"
          viewBox="0 0 1440 54"
        >
          <path
            fill="currentColor"
            d="M0 22L120 16.7C240 11 480 1.00001 720 0.700012C960 1.00001 1200 11 1320 16.7L1440 22V54H1320C1200 54 960 54 720 54C480 54 240 54 120 54H0V22Z"
          />
        </svg>
        <div className="mx-auto px-4 pt-12 sm:max-w-xl md:max-w-full md:px-24 lg:max-w-screen-xl lg:px-8">
          <div className="row-gap-10 mb-7 grid gap-16 lg:grid-cols-5">
            <div className="md:max-w-md lg:col-span-2">
              <Link
                href="/"
                color="foreground"
                aria-label="Retiral"
                title="home"
                className="inline-flex items-center"
              >
                <Scale />
                <span className="ml-2 text-lg font-bold uppercase tracking-tight">
                  {siteConfig.name}
                </span>
              </Link>
              <div className="mt-4 lg:max-w-sm">
                <p className="my-4 text-sm">{siteConfig.footerDescription1}</p>
                <p className="text-sm ">{siteConfig.footerDescription1}</p>
              </div>
            </div>
            <div className="row-gap-8 grid grid-cols-2 gap-5 md:grid-cols-3 lg:col-span-3">
              <div>
                <p className="text-teal-accent-400 font-semibold tracking-wide">
                  Development Team
                </p>
                <ul className="mt-2 space-y-2">
                  {developers.map((developer, index) => {
                    return (
                      <li key={index}>
                        <Link
                          key={index}
                          color="foreground"
                          aria-label={developer.name}
                          isExternal
                          href={developer.linkedin}
                          underline="hover"
                        >
                          {developer.name}
                        </Link>
                      </li>
                    );
                  })}
                </ul>
              </div>
              <div>
                <p className="font-semibold tracking-wide">Pages</p>
                <ul className="mt-2 space-y-2">
                  {pagesForFooter.map((Page, index) => {
                    return (
                      <li className="flex gap-x-3" key={index}>
                        <span>{Page.icon}</span>
                        <Link
                          key={index}
                          color="foreground"
                          href={Page.href}
                          className="transition-colors duration-300 "
                        >
                          {Page.title}
                        </Link>
                      </li>
                    );
                  })}
                </ul>
              </div>
              <div>
                <p className="text-teal-accent-400 font-semibold tracking-wide">
                  Go to
                </p>
                <ul className="mt-2 space-y-2">
                  <li>
                    <Link
                      href="#hero"
                      color="foreground"
                      className="transition-colors duration-300 "
                    >
                      TOP
                    </Link>
                  </li>
                  <li>
                    <Link
                      color="foreground"
                      href="#about"
                      className="transition-colors duration-300 "
                    >
                      About
                    </Link>
                  </li>
                  <li>
                    <Link
                      href="#faq"
                      color="foreground"
                      className="transition-colors duration-300 "
                    >
                      Frequently Asked Questions
                    </Link>
                  </li>
                  <li>
                    <Link
                      href="#pricing"
                      color="foreground"
                      className="transition-colors duration-300 "
                    >
                      Pricing
                    </Link>
                  </li>
                </ul>
              </div>
            </div>
          </div>
          <Divider className="mb-4 " />
          <div className="flex flex-col justify-between px-3 pb-5 sm:flex-row">
            <p className="text-sm ">
              © Copyright 2023 | Privacy Policy | Terms of Use
            </p>
            <div className="mt-4 flex items-center space-x-4 sm:mt-0">
              <Link
                isExternal
                href=""
                aria-label="Check out our instagram page"
              >
                <Instagram className="dark:text-default-500 text-black transition-colors hover:text-pink-500 " />
              </Link>
              <Link isExternal href="" aria-label="Check out our twitter page">
                <Twitter className="dark:text-default-500 text-black transition-colors hover:text-blue-400" />
              </Link>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
}
