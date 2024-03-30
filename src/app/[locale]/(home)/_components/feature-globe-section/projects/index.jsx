'use client';
import { useState } from 'react';
import styles from './style.module.scss';
import Titles from './titles';
import Descriptions from './descriptions';

const data = [
    {
        title: "Experience Unmatched",
        description: "Dive into an era where your voice commands transcend reality, offering unparalleled precision in speech recognition, amidst the ever-present noise of life's hustle.",
        speed: 0.8
    },
    {
        title: "Global Voice Automation",
        description: "Explore the globe with a voice assistant that understands the nuances of over 30 languages, adapting its comprehension to your unique vocal signature for an intimate digital experience.",
        speed: 0.82
    },
    // {
    //     title: "Automation Unleashed",
    //     description: "Unleash the full potential of your workflow with cutting-edge automation, where natural language evolves into powerful commands executed with ease and efficiency.",
    //     speed: 0.85
    // },
    {
        title: "For Next-Level productivity",
        description: "Elevate to the next level with a voice assistant that transforms terminal commands into conversations, merging intuition with technology to revolutionize your digital dialogue.",
        speed: 0.88
    },
    {
        title: "Interactive Experiences",
        description: "Step into interactive realms where web searches are customized treasures, revealed through the lens of your personal inquiries, all displayed in an intuitive browser interface.",
        speed: 0.9
    },
    {
        title: "Through Intelligent",
        description: "Navigate through your tasks with an intelligence that anticipates your needs, offering smart suggestions and executing a variety of functions based on your voice inputs.",
        speed: 0.92
    },
    {
        title: "Task Matching",
        description: "Match your verbal commands with the assistant’s vast repertoire of tasks, ensuring that even the most complex requests find their resolution in the blink of an eye.",
        speed: 0.94
    },
    // {
    //     title: "And Intuitive UI,",
    //     description: "Interact with an interface designed not just for the eye but for the ear, blending visual beauty with auditory elegance for a user experience that's as intuitive as it is stunning.",
    //     speed: 0.96
    // },
    // {
    //     title: "Ensuring Rapid",
    //     description: "Guaranteeing swift responses and peak performance, this assistant is powered by the most efficient AI/ML algorithms, ensuring that your commands are met with instant action.",
    //     speed: 0.98
    // },
    {
        title: "Respecting Your Privacy,",
        description: "Conclude your journey with the assurance of stringent privacy measures, where your voice activates not just commands but a shield that guards your personal data with utmost integrity.",
        speed: 1
    }
]

export default function Projects() {
    const [selectedProject, setSelectedProject] = useState(null)
    return (
        <div className={styles.container}>
            <Titles data={data} setSelectedProject={setSelectedProject} />
            <Descriptions data={data} selectedProject={selectedProject} />
        </div>
    )
}

