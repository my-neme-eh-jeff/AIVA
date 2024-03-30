"use client"
import { motion } from 'framer-motion';
import { useLocale } from "next-intl";
import { useRouter } from "next/navigation";
import { useTransition } from "react";
import { mountAnim, opacity, slideLeft } from '../anim';
import Link from './link';
import styles from './style.module.scss';

const menu = [
  {
    title: "Voice Search Engine",
    description: "To See Everything on the web",
    images: ['projects1.jpg', 'projects2.jpg']
  },
  {
    title: "Voice Terminal",
    description: "Use our unique audio commands system",
    images: ['agence1.jpg', 'agence2.jpg']
  },
  {
    title: "Contact Us",
    description: "Get in touch with us!",
    images: ['contact1.jpg', 'contact2.jpg']
  }
]

export default function index({ closeMenu }) {
  const [isPending, startTransition] = useTransition();
  const router = useRouter();

  const onSelectChange = (e) => {
    console.log(e)
    startTransition(() => {
      router.replace(`/${e}`);
    });
  };

  return (
    <motion.div className={styles.menu} variants={opacity} initial="initial" animate="enter" exit="exit">
      <div className={styles.header}>
        <motion.svg
          variants={slideLeft}
          {...mountAnim}
          onClick={() => { closeMenu() }}
          width="68"
          height="68"
          viewBox="0 0 68 68"
          fill="none"
          xmlns="http://www.w3.org/2000/svg">
          <path d="M1.5 1.5L67 67" stroke="white" />
          <path d="M66.5 1L0.999997 66.5" stroke="white" />
        </motion.svg>
      </div>

      <div className={styles.body}>
        {
          menu.map((el, index) => {
            return <Link data={el} index={index} key={index} />
          })
        }
      </div>

      <motion.div
        variants={opacity}
        {...mountAnim}
        custom={0.5}
        className={styles.footer}>
        <p onClick={() => onSelectChange("eng")}>ENG</p>
        <p onClick={() => onSelectChange("hin")}>HIN</p>
      </motion.div>
    </motion.div>
  )
}
