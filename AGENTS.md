# AGENTS

<skills_system priority="1">

## Available Skills

<!-- SKILLS_TABLE_START -->
<usage>
When users ask you to perform tasks, check if any of the available skills below can help complete the task more effectively. Skills provide specialized capabilities and domain knowledge.

How to use skills:
- Invoke: Bash("openskills read <skill-name>")
- The skill content will load with detailed instructions on how to complete the task
- Base directory provided in output for resolving bundled resources (references/, scripts/, assets/)

Usage notes:
- Only use skills listed in <available_skills> below
- Do not invoke a skill that is already loaded in your context
- Each skill invocation is stateless
</usage>

<available_skills>

<skill>
<name>blog-writer</name>
<description>Write technical blog posts and tutorials in the distinctive style of Liao Xuefeng (liaoxuefeng.com). Use this skill when asked to write blog posts, tutorials, technical articles, or educational content that should be beginner-friendly, engaging, and use progressive teaching methods with clear examples and analogies. The style features friendly tone, step-by-step explanations, abundant examples, life analogies, and encouragement for learners.</description>
<location>project</location>
</skill>

</available_skills>
<!-- SKILLS_TABLE_END -->

</skills_system>
