# Claude Plugins Marketplace 계획

## 목표

Claude Code에서 사용할 수 있는 플러그인 모음을 GitHub에서 배포하여,
다른 사용자들이 쉽게 설치하고 사용할 수 있도록 한다.

---

## 디렉토리 구조

```
claude-plugins/
├── .claude-plugin/
│   └── marketplace.json          # 마켓플레이스 정의 (플러그인 목록)
├── codex-review-hook/            # 첫 번째 플러그인
│   ├── .claude-plugin/
│   │   └── plugin.json           # 플러그인 메타데이터
│   ├── hooks/
│   │   └── hooks.json            # hook 설정
│   ├── scripts/
│   │   └── codex-review.sh       # 실행 스크립트
│   └── README.md                 # 플러그인 사용법
├── PLAN.md                       # 이 파일
└── README.md                     # 마켓플레이스 전체 README
```

---

## 플러그인 1: codex-review-hook

### 기능
- Claude가 `git commit` 실행 전에 자동으로 `codex exec review --uncommitted` 실행
- 전체 로그가 아닌 **최종 리뷰 결과만** Claude에게 전달 (context 절약)
- codex 미설치 시 친절한 안내 메시지 표시

### 동작 방식
1. `PreToolUse` hook으로 `Bash` 도구 실행 감지
2. 명령어가 `git commit`인지 확인
3. `codex exec review --uncommitted` 실행
4. 출력에서 `Review comment:` 이후만 추출
5. `systemMessage`로 Claude에게 전달

### Prerequisites (사용자가 직접 설치 필요)
```bash
npm install -g @openai/codex
codex auth
```

---

## 설치 방법 (사용자용)

```bash
# 1. 마켓플레이스 등록
/plugin marketplace add github:jinto/claude-plugins

# 2. 플러그인 설치
/plugin install codex-review-hook@claude-plugins
```

---

## 파일별 작성 내용

### 1. `.claude-plugin/marketplace.json`
```json
{
  "name": "claude-plugins",
  "owner": { "name": "jinto" },
  "plugins": [
    {
      "name": "codex-review-hook",
      "source": "./codex-review-hook",
      "description": "Auto code review with OpenAI Codex before git commit"
    }
  ]
}
```

### 2. `codex-review-hook/.claude-plugin/plugin.json`
```json
{
  "name": "codex-review-hook",
  "description": "Automatically run OpenAI Codex review before git commit",
  "version": "1.0.0",
  "author": { "name": "jinto" }
}
```

### 3. `codex-review-hook/hooks/hooks.json`
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "codex-review-hook-script"
          }
        ]
      }
    ]
  }
}
```

> 주의: 플러그인에서 스크립트 경로 참조 방식 확인 필요

### 4. `codex-review-hook/scripts/codex-review.sh`
- stdin에서 JSON 읽기 (hook input)
- `git commit` 명령인지 확인
- codex 설치 여부 확인
- `codex exec review --uncommitted` 실행
- `Review comment:` 이후만 추출
- JSON으로 `systemMessage` 반환

---

## 향후 추가 가능한 플러그인 아이디어

| 플러그인명 | 설명 |
|-----------|------|
| `lint-on-save` | 파일 저장 시 자동 lint |
| `test-on-edit` | 테스트 파일 수정 시 자동 테스트 실행 |
| `commit-message-helper` | 커밋 메시지 자동 생성 |

---

## 작업 순서

1. [x] PLAN.md 작성
2. [ ] marketplace.json 작성
3. [ ] codex-review-hook/plugin.json 작성
4. [ ] codex-review-hook/hooks/hooks.json 작성
5. [ ] codex-review-hook/scripts/codex-review.sh 작성
6. [ ] codex-review-hook/README.md 작성
7. [ ] 마켓플레이스 README.md 작성
8. [ ] git init & push to github:jinto/claude-plugins
9. [ ] 실제 설치 테스트
