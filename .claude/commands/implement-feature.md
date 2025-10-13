---
description: Implement a planned feature following PLAN.md and project architecture
---

Implement feature: $ARGUMENTS

Execute systematic feature implementation workflow:

## Phase 1: Preparation

1. **Verify Prerequisites**
   - Check PLAN.md exists
   - If missing: Suggest creating a plan first through conversation
   - Read CLAUDE.md to understand architecture patterns
   - Read PLAN.md to understand feature scope

2. **Clarify Requirements**
   - Review feature requirements for: $ARGUMENTS
   - Identify affected features and layers
   - **ASK FOR CLARIFICATION** if any architectural decisions are unclear:
     - Feature structure or location
     - Which layers are needed (domain/data/presentation)
     - Database requirements
     - State management approach
     - Navigation patterns
     - Dependencies between features
   - Wait for confirmation before proceeding

## Phase 2: Implementation

3. **Create Feature Structure**
   - Generate directories following Feature-First architecture
   - Create corresponding test directories
   - Follow patterns defined in CLAUDE.md

4. **Implement Layers in Order**
   - **Domain Layer First** (entities, repository interfaces)
     - Follow dart_mappable patterns from CLAUDE.md
     - Create clean, framework-independent domain logic
   - **Data Layer Second** (models, repositories, drift tables if needed)
     - Implement repository interfaces
     - Add drift tables if persistence needed
     - Follow database patterns from CLAUDE.md
   - **Presentation Layer Last** (providers, pages, widgets)
     - Use Riverpod 3.0 patterns from CLAUDE.md
     - Create UI following design system (shadcn_ui)
     - Keep widgets under 300 lines

5. **Add Navigation** (if new pages created)
   - Update auto_route configuration
   - Add routes to router

## Phase 3: Code Generation

6. **Run Code Generation**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
   - Generates: dart_mappable (*.mapper.dart)
   - Generates: riverpod (*.g.dart)
   - Generates: auto_route (*.gr.dart)
   - Generates: drift (*.g.dart for DAOs)
   - Check for errors and fix if needed

## Phase 4: Testing

7. **Create Comprehensive Tests**
   - Unit tests for domain logic (entities, use cases)
   - Unit tests for repositories
   - Widget tests for UI components
   - Follow testing patterns from CLAUDE.md
   - Target: 75% coverage for new code
   - Include edge cases and error scenarios

8. **Run Quality Checks**
   ```bash
   dart format .
   flutter analyze
   dart run custom_lint
   flutter test --coverage
   ```
   - Ensure all tests pass
   - No analyzer warnings (very_good_analysis)
   - No custom lint issues (Riverpod lints, etc.)
   - Code properly formatted
   - Coverage meets target

## Phase 5: Documentation & Completion

9. **Update Documentation**
   - Mark completed tasks in PLAN.md
   - Add inline documentation (dartdoc comments) for complex logic
   - **Update CLAUDE.md if:**
     - New architectural pattern emerged
     - New convention should be followed project-wide
     - Important lesson learned that affects future features
     - New dependency with specific usage guidelines
   - **Update README.md if:**
     - New user-facing feature added
     - Setup/build instructions changed
     - New platform support added
   - **Create ADR (Architecture Decision Record) if:**
     - Significant architectural decision made (choice between approaches)
     - Trade-offs were evaluated (performance, complexity, accuracy)
     - Decision affects multiple features or future development
     - Create in: `docs/adr/NNNN-decision-title.md`
     - Use template from `docs/adr/template.md`

10. **Completion Summary**
    - List what was implemented
    - Show test coverage achieved
    - Highlight any issues or concerns
    - Suggest manual testing steps
    - Suggest next steps from PLAN.md

## Important Reminders

- **Follow CLAUDE.md** for all architectural patterns and coding standards
- **Don't make assumptions** - ask for clarification when unclear
- **Implement incrementally** - one layer at a time, verify each step
- **Run code generation** after creating/modifying models or providers
- **Test as you go** - don't wait until the end
- **For color mixing calculations** - use LAB color space for paint mixing ratios and color matching (Delta E)
- **For color display** - convert to RGB/Flutter Color for UI rendering
- **Hot restart required** after adding new routes

## Common Issues

- **Missing imports** after code generation → Check file names match
- **Provider not found** → Ensure code generation ran successfully  
- **Route not working** → Hot restart required, not just hot reload
- **Drift errors** → Check table definitions match entity fields
- **Test failures** → Verify mocks are set up correctly

---

**Remember:** This command provides the workflow checklist. CLAUDE.md contains the architectural patterns and code standards to follow during implementation.