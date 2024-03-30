'use client';
import { useState } from 'react';
import styles from './style.module.scss';
import Titles from './titles';
import Descriptions from './descriptions';
import { useTranslations } from 'next-intl';

export default function Projects() {
    const t = useTranslations("data")
    const data = [
        {
            title: t("1.title"),
            description: t("1.description"),
            speed: t("1.speed")
        },
        {
            title: t("2.title"),
            description: t("2.description"),
            speed: t("2.speed")
        },
        {
            title: t("3.title"),
            description: t("3.description"),
            speed: t("3.speed")
        },
        {
            title: t("5.title"),
            description: t("5.description"),
            speed: t("5.speed")
        },
        {
            title: t("6.title"),
            description: t("6.description"),
            speed: t("6.speed")
        },
        {
            title: t("7.title"),
            description: t("7.description"),
            speed: t("7.speed")
        }
    ]

    const [selectedProject, setSelectedProject] = useState(null)
    return (
        <div className={styles.container}>
            <Titles data={data} setSelectedProject={setSelectedProject} />
            <Descriptions data={data} selectedProject={selectedProject} />
        </div>
    )
}

