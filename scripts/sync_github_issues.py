#!/usr/bin/env python3
"""
Sync local issues in docs/issues/ with GitHub issues for Jonathan-Llopis/Roll_and_Reserve_App.
"""

import os
import subprocess
import json
import re

REPO = "Jonathan-Llopis/Roll_and_Reserve_App"

def run_cmd(cmd):
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return result.returncode, result.stdout.strip(), result.stderr.strip()

def is_gh_authenticated():
    code, out, _ = run_cmd("gh auth status")
    return code == 0

def get_open_github_issues():
    code, out, err = run_cmd(f"gh issue list --repo {REPO} --state all --limit 100 --json number,title,state,body")
    if code != 0:
        print(f"Error fetching issues: {err}")
        return []
    return json.loads(out)

def update_issue(number, title=None, body=None):
    cmd = ["gh", "issue", "edit", str(number), "--repo", REPO]
    if title:
        cmd.extend(["--title", title])
    if body:
        cmd.extend(["--body", body])
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.returncode == 0, result.stderr

def create_issue(title, body):
    cmd = ["gh", "issue", "create", "--repo", REPO, "--title", title, "--body", body]
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.returncode == 0, result.stdout.strip() if result.returncode == 0 else result.stderr

def main():
    if not is_gh_authenticated():
        print("gh is not authenticated. Please authenticate first.")
        return

    print("gh is authenticated. Fetching current GitHub issues...")
    gh_issues = get_open_github_issues()
    gh_by_number = {i['number']: i for i in gh_issues}
    print(f"Found {len(gh_issues)} issues on GitHub.")

    # 1. Update #25 (Testing)
    if 25 in gh_by_number:
        print("Updating GitHub Issue #25 (Testing)...")
        body_25 = """### Problem
The project previously had 0% automated test coverage with no `test/` directory.

### Status: COMPLETED ✅
- [x] Create the `test/` directory structure mirroring `lib/` (core, data, domain, presentation, helpers).
- [x] Add `bloc_test: ^10.0.0` and `mocktail: ^1.0.4` to `dev_dependencies`.
- [x] Implement unit tests for core models, helper functions, and repositories.
- [x] Implement BLoC tests (e.g. `LanguageBloc`).
- [x] Verified: `flutter test` passes with 100% success (23 tests passing).
- [x] Verified: `flutter analyze` passes with 0 issues.
"""
        update_issue(25, body=body_25)

    # 2. Update #24 (Date parsing)
    if 24 in gh_by_number:
        print("Updating GitHub Issue #24 (Date Format)...")
        body_24 = """### Problem
In `lib/data/models/functions_for_models.dart`, date and hour functions performed manual slicing prone to RangeError.

### Status: PARTIALLY COMPLETED / IN PROGRESS 🔄
- [x] Protected `getDate`, `getHour`, and `getIsoDate` with length boundary guards and fallback values (tests verified).
- [ ] Migrate date parsing to `DateTime.tryParse()` and formatting using `intl` `DateFormat`.
- [ ] Relocate date helper utilities to `lib/core/utils/`.
"""
        update_issue(24, body=body_24)

    # 3. Update #21 (Network ApiClient)
    if 21 in gh_by_number:
        print("Updating GitHub Issue #21 (Network ApiClient)...")
        body_21 = """### Problem
Decentralized `http.Client` calls, hardcoded headers, lack of request timeouts and retry mechanisms.

### Status: IN PROGRESS 🔄
- [x] Fixed filename typos (`shop_datasoruce.dart` -> `shop_datasource.dart`, `table_respository.dart` -> `table_repository.dart`).
- [x] Created `TokenProvider` abstraction to inject authentication tokens safely.
- [ ] Implement central `ApiClient` with Dio, timeout interceptor, and retry policies.
- [ ] Standardize domain failures across all repositories.
"""
        update_issue(21, body=body_21)

    # 4. Upload remaining issues from docs/issues/ that are not yet on GitHub
    new_issues = [
        {
            "title": "Security: Eradicate unsafe force-unwrapping (!) and handle null tokens across Repositories",
            "file": "docs/issues/ISSUE-02-seguridad-token-desempaquetado-errores.md"
        },
        {
            "title": "Navigation: Fix async redirection loops and context lookups in GoRouter",
            "file": "docs/issues/ISSUE-03-gorouter-redireccion-asincrona.md"
        },
        {
            "title": "Navigation: Eradicate imperative Navigator.push in favor of declarative GoRouter routes",
            "file": "docs/issues/ISSUE-04-erradicacion-navigator-push-rutas.md"
        },
        {
            "title": "Lifecycle: Fix memory leak in AppLinks StreamSubscription and secure .env loading",
            "file": "docs/issues/ISSUE-05-fuga-memoria-applinks-env.md"
        },
        {
            "title": "Architecture: Enforce Clean Architecture boundaries for AI prompts, services and use cases",
            "file": "docs/issues/ISSUE-08-limites-clean-architecture-prompts-usecases.md"
        },
        {
            "title": "Refactor: Modularize dependency injection and migrate BLoC constructors to named parameters",
            "file": "docs/issues/ISSUE-11-inyeccion-dependencias-modular-parametros-nombrados.md"
        },
        {
            "title": "Domain: Implement Equatable and copyWith across Domain Entities for structural equality",
            "file": "docs/issues/ISSUE-12-equatable-inmutabilidad-entidades.md"
        },
        {
            "title": "Performance: Implement pagination and infinite scrolling in Shop and Reservation lists",
            "file": "docs/issues/ISSUE-14-paginacion-scroll-infinito-listas.md"
        },
        {
            "title": "UI: Centralize styling into AppTheme and standardize ScreenUtil responsive sizing",
            "file": "docs/issues/ISSUE-15-unificacion-apptheme-screenutil.md"
        },
        {
            "title": "Offline: Local SQLite persistence for AI chat history",
            "file": "docs/issues/ISSUE-16-persistencia-local-historial-chat-ia.md"
        }
    ]

    for item in new_issues:
        path = item["file"]
        if os.path.exists(path):
            with open(path, "r", encoding="utf-8") as f:
                content = f.read()
            # Check if an issue with similar title already exists
            exists = any(item["title"].lower() in (i["title"].lower()) for i in gh_issues)
            if not exists:
                print(f"Creating GitHub issue: {item['title']}...")
                ok, res = create_issue(item["title"], content)
                if ok:
                    print(f"Created: {res}")
                else:
                    print(f"Failed to create: {res}")
            else:
                print(f"Issue already exists: {item['title']}")

if __name__ == "__main__":
    main()
