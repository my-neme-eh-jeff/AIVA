import React from "react";
import SmoothScroll from "./smoothScroll";
import Earth from "./earth";
import Projects from "./projects";
import styles from './page.module.scss'

export default function FeatureGlobeSection() {
  return (
    <SmoothScroll>
      <main className={styles.main}>
        <Earth />
        <Projects />
      </main>
    </SmoothScroll>
  );
}
