import React from "react";
import { MaskText } from "./mask-text";
import FloatingPhone from "./floating-phone";

export default function FeaturesSection() {
  return (
    <div className="flex justify-around">
      <div className="my-auto">
        <MaskText />
      </div>
      <div>
        <FloatingPhone />
      </div>
    </div>
  );
}
