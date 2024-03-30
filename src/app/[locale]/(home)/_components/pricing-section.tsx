"use client";
import { Button } from "@nextui-org/button";
import { Divider } from "@nextui-org/divider";
import { Switch } from "@nextui-org/react";
import { motion, useMotionTemplate, useMotionValue } from "framer-motion";
import { Check, X } from "lucide-react";
import { useState, type MouseEvent } from "react";

function PricingSection() {
  const [isSelected, setIsSelected] = useState(true);
  let mouseX = useMotionValue(0);
  let mouseY = useMotionValue(0);
  
  function handleMouseMove({ currentTarget, clientX, clientY }: MouseEvent) {
    let { left, top } = currentTarget.getBoundingClientRect();
    mouseX.set(clientX - left);
    mouseY.set(clientY - top);
  }

  const pricingSectionVariants = [
    {
      title: "Gold membership plan",
      Gradientcolor: "rgb(253 ,224 ,71,0.23)",
      price: `${isSelected ? "1000₹" : "9000₹"}`,
      description: "Get Most of our ML features",
      features: [
        {
          availible: true,
          text: "Retirement calculator",
        },
        {
          availible: true,
          text: "Interact in user forums",
        },
        {
          availible: true,
          text: "Financial advice chatbot",
        },
        {
          availible: false,
          text: "Data driven insights for future planning",
        },
      ],
    },
    {
      title: "Diamond membership plan",
      Gradientcolor: "rgb(147 ,197, 253,0.27)",
      price: `${isSelected ? "2000₹" : "15000₹"}`,
      description: "Get All of our ML features",
      features: [
        {
          availible: true,
          text: "Retirement calculator",
        },
        {
          availible: true,
          text: "Interact in user forums",
        },
        {
          availible: true,
          text: "Financial advice chatbot",
        },
        {
          availible: true,
          text: "Data driven insights for future planning",
        },
      ],
    },
    {
      title: "FREE trial",
      Gradientcolor: "rgb(23, 201, 100,0.17)",
      price: "0₹",
      buttonText: "Start now!",
      description: "Get Most of our ML features",
      features: [
        {
          availible: true,
          text: "Retirement calculator",
        },
        {
          availible: true,
          text: "Interact in user forums",
        },
        {
          availible: false,
          text: "Financial advice chatbot",
        },
        {
          availible: false,
          text: "Data driven insights for future planning",
        },
      ],
    },
  ];

  return (
    <>
      <h1
        className="mt-20 block text-center text-3xl md:text-5xl"
        data-aos="fade-left"
      >
        Our Subscription Plans
      </h1>

      <div className="mt-6 flex justify-center">
        <Switch isSelected={isSelected} onValueChange={setIsSelected}>
          {isSelected ? "Yearly" : "Monthly"}
        </Switch>
      </div>

      <div className="mx-auto px-4 sm:px-6 sm:py-6 lg:max-w-6xl lg:px-8 xl:max-w-7xl">
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-3 sm:items-center md:gap-8">
          {pricingSectionVariants.map((variant, index) => (
            <div
              key={index}
              data-aos={`${
                index === 0
                  ? "fade-right"
                  : index === 1
                    ? "fade-up"
                    : "fade-left"
              }`}
              data-aos-delay={index === 1 ? "550" : "650"}
              className={`group relative z-30 mt-12 rounded-md border border-blue-300 border-white/10 bg-gray-200 p-6  px-8 py-16  shadow-2xl dark:bg-gray-950 sm:px-8 lg:p-8
                   ${index !== 1 ? "min-h-[26rem]" : "min-h-[30rem]"} `}
              onMouseMove={handleMouseMove}
            >
              <motion.div
                className="pointer-events-none absolute -inset-px z-30 rounded-md opacity-0 transition duration-300 group-hover:opacity-100"
                style={{
                  background: useMotionTemplate`
                        radial-gradient(
                          300px circle at ${mouseX}px ${mouseY}px,
                          ${variant.Gradientcolor},
                          transparent 70%
                        )
                      `,
                }}
                onMouseMove={handleMouseMove}
              />

              <div className="text-center">
                <h2 className="font-mono text-lg">
                  {variant.title}
                  <span className="sr-only">Plan</span>
                </h2>

                <p className="mt-2 sm:mt-4">
                  <strong className="text-3xl font-bold text-stone-800 dark:text-stone-400 sm:text-4xl">
                    {variant.price}
                  </strong>

                  <span className="text-sm font-medium ">/month</span>
                </p>
                <p className="mt-4 text-stone-500">{variant.description}</p>
              </div>

              <Divider className="mt-4" />

              <ul className="mt-6 space-y-2 ">
                {variant.features.map((feature, indexForFeature) => (
                  <li
                    key={indexForFeature}
                    className="flex items-center gap-1 overflow-y-hidden"
                  >
                    {feature.availible ? (
                      <Check className="text-success" />
                    ) : (
                      <X className="text-danger" />
                    )}
                    <span className="dark:text-default-500 text-stone-600">
                      {feature.text}
                    </span>
                  </li>
                ))}
              </ul>

              <Button
                variant="shadow"
                color="success"
                fullWidth={index === 1}
                className={`${
                  index === 1
                    ? "z-50 mx-auto mt-6"
                    : "absolute -bottom-5 left-1/2 z-50 w-[56%] -translate-x-1/2 transform"
                }`}
              >
                {variant.buttonText ?? "Get Started"}
              </Button>
            </div>
          ))}
        </div>
      </div>
    </>
  );
}

export default PricingSection;
