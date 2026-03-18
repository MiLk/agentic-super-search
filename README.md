# 🍑 ass — Agentic Super Search

> The result of decades of research in information retrieval, cognitive search theory, and agentic AI orchestration.

ass is a groundbreaking suite of search utilities built on a proprietary multi-layered inference engine, combining advances in semantic heuristics, recursive query decomposition, and adversarial self-verification. The culmination of years of academic work in distributed knowledge synthesis and large-scale corpus traversal — now available as a bash script.

## Requirements

- [`claude` CLI](https://github.com/anthropics/claude-code) installed and authenticated
- `bash` or `zsh`

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/MiLk/agentic-super-search/main/install.sh | bash
```

Then reload your shell:

```bash
source ~/.ass-tools.sh
```

## Commands

### `dumbass` — Baseline Corpus Traversal Engine (BCTE)

Leverages a breadth-first lexical scan across the entire corpus with contextual window amplification, feeding raw signal into a high-dimensional summarization pipeline.

```bash
dumbass "how is authentication handled"
```

### `badass` — Adaptive Query Synthesis (AQS)

Employs a two-phase retrieval architecture: a generative pre-search layer dynamically constructs an optimized traversal expression, which is then executed against the corpus and reconciled with the original intent vector.

```bash
badass "where are environment variables configured"
```

### `hardass` — Recursive Adversarial Verification Loop (RAVL)

Our flagship algorithm. Implements a closed-loop agentic search protocol with built-in epistemic self-assessment. Each iteration runs a full AQS cycle, followed by a critic pass that evaluates answer sufficiency against the original query embedding. Convergence is guaranteed or your money back.

```bash
hardass "what does the deploy script do"
hardass "what does the deploy script do" 10  # override max convergence cycles
```

### `kickass` — Parallel Ensemble Arbitration (PEA)

Spawns multiple independent search agents concurrently across the full strategy spectrum, collecting divergent answer candidates which are then fed into a meta-reasoning arbitration layer for optimal response synthesis.

```bash
kickass "how is authentication handled"
```

### `smartass` — Direct Intent Projection (DIP)

Bypasses corpus traversal entirely, routing the raw query through a pure semantic inference channel. Recommended for high-level reasoning tasks where filesystem grounding is unnecessary.

```bash
smartass "explain what this codebase does"
```

## Want to go deeper?

If the theoretical foundations behind ass intrigue you — agentic search, multi-agent orchestration, recursive verification loops, adversarial self-assessment — you might enjoy [**Agentic Engineering: Building Autonomous AI Systems with Python**](https://www.amazon.com/dp/B0GSCQTNB2) by the same author. Framework deep dives, real-world case studies, and none of the profanity.

## Uninstall

Remove `~/.ass-tools.sh` and the `source` line from your `~/.bashrc` / `~/.zshrc`.

## License

[WTFPL](http://www.wtfpl.net/) — Do What The F*ck You Want To Public License.
