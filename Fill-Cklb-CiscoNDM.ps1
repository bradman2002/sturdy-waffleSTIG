<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>CKLB Auto-Fill — Cisco IOS Switch NDM</title>
<style>
  :root {
    --bg: #0d1117;
    --panel: #151b23;
    --border: #2a3441;
    --text: #d6dde5;
    --dim: #7d8b9a;
    --accent: #4a9eda;
    --ok: #3fb950;
    --open: #e5534b;
    --mono: "SF Mono", "Cascadia Code", Consolas, monospace;
  }
  * { box-sizing: border-box; }
  body {
    background: var(--bg);
    color: var(--text);
    font-family: -apple-system, "Segoe UI", Roboto, sans-serif;
    margin: 0;
    padding: 2rem 1.5rem 4rem;
  }
  .wrap { max-width: 780px; margin: 0 auto; }
  h1 {
    font-size: 1.4rem;
    font-weight: 600;
    margin: 0 0 0.25rem;
    letter-spacing: -0.01em;
  }
  .subtitle { color: var(--dim); font-size: 0.9rem; margin: 0 0 2rem; }
  .card {
    background: var(--panel);
    border: 1px solid var(--border);
    border-radius: 10px;
    padding: 1.25rem 1.4rem;
    margin-bottom: 1.25rem;
  }
  .card h2 {
    font-size: 0.8rem;
    text-transform: uppercase;
    letter-spacing: 0.06em;
    color: var(--dim);
    margin: 0 0 0.9rem;
    font-weight: 600;
  }
  .drop {
    border: 1.5px dashed var(--border);
    border-radius: 8px;
    padding: 1.1rem;
    text-align: center;
    cursor: pointer;
    transition: border-color 0.15s, background 0.15s;
    font-size: 0.88rem;
  }
  .drop:hover, .drop.drag {
    border-color: var(--accent);
    background: rgba(74, 158, 218, 0.06);
  }
  .drop input { display: none; }
  .filename {
    margin-top: 0.6rem;
    font-family: var(--mono);
    font-size: 0.78rem;
    color: var(--accent);
    word-break: break-all;
  }
  .row { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
  button.run {
    width: 100%;
    background: var(--accent);
    color: #06131f;
    border: none;
    border-radius: 8px;
    padding: 0.85rem;
    font-size: 0.95rem;
    font-weight: 600;
    cursor: pointer;
    margin-top: 0.5rem;
    transition: filter 0.15s;
  }
  button.run:hover { filter: brightness(1.08); }
  button.run:disabled { background: var(--border); color: var(--dim); cursor: not-allowed; }
  .summary {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(110px, 1fr));
    gap: 0.75rem;
    margin: 1.25rem 0;
  }
  .stat { text-align: center; }
  .stat .n { font-size: 1.6rem; font-weight: 700; font-family: var(--mono); }
  .stat .l { font-size: 0.72rem; color: var(--dim); text-transform: uppercase; letter-spacing: 0.05em; }
  .stat.ok .n { color: var(--ok); }
  .stat.open .n { color: var(--open); }
  .stat.manual .n { color: var(--accent); }
  .stat.error .n { color: var(--open); }
  .rules-banner {
    font-size: 0.78rem;
    color: var(--dim);
    background: rgba(255,255,255,0.02);
    border: 1px solid var(--border);
    border-radius: 8px;
    padding: 0.7rem 0.9rem;
    margin-bottom: 1rem;
  }
  .rules-banner strong { color: var(--text); }
  table { width: 100%; border-collapse: collapse; font-size: 0.83rem; }
  th { text-align: left; color: var(--dim); font-weight: 600; font-size: 0.72rem; text-transform: uppercase; letter-spacing: 0.04em; padding: 0.4rem 0.5rem; border-bottom: 1px solid var(--border); }
  td { padding: 0.55rem 0.5rem; border-bottom: 1px solid var(--border); vertical-align: top; }
  tr:last-child td { border-bottom: none; }
  .vid { font-family: var(--mono); color: var(--accent); white-space: nowrap; }
  .status { font-weight: 700; font-size: 0.72rem; text-transform: uppercase; white-space: nowrap; }
  .status.na { color: var(--ok); }
  .status.open { color: var(--open); }
  .status.error { color: var(--open); }
  .confidence { font-size: 0.68rem; text-transform: uppercase; color: var(--dim); white-space: nowrap; }
  .confidence.high { color: var(--ok); }
  .confidence.medium { color: var(--accent); }
  .confidence.low { color: var(--open); }
  .detail { color: var(--dim); font-size: 0.8rem; }
  .download {
    display: block;
    width: 100%;
    text-align: center;
    background: var(--ok);
    color: #06210c;
    text-decoration: none;
    border-radius: 8px;
    padding: 0.85rem;
    font-weight: 600;
    margin-top: 1rem;
  }
  .note {
    font-size: 0.78rem;
    color: var(--dim);
    line-height: 1.5;
    margin-top: 1.5rem;
    padding-top: 1.25rem;
    border-top: 1px solid var(--border);
  }
  .hidden { display: none; }
  .device-block { margin-bottom: 1.5rem; }
  .device-block:last-child { margin-bottom: 0; }
  .device-head {
    display: flex;
    justify-content: space-between;
    align-items: baseline;
    margin-bottom: 0.5rem;
  }
  .device-head h3 { margin: 0; font-size: 0.95rem; font-family: var(--mono); color: var(--text); }
  .device-head .counts { font-size: 0.78rem; color: var(--dim); }
  .status.manual { color: var(--dim); }
  .evidence { font-size: 0.78rem; font-family: var(--mono); color: var(--text); }
  .evidence div { padding: 0.1rem 0; }
  .evidence .none { color: var(--dim); font-style: italic; font-family: inherit; }
  .subhead {
    font-size: 0.72rem;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    color: var(--dim);
    margin: 1rem 0 0.4rem;
  }
  .risky-panel {
    border: 1px solid var(--border);
    border-radius: 8px;
    margin-bottom: 0.75rem;
    overflow: hidden;
  }
  .risky-header {
    display: flex;
    gap: 0.6rem;
    align-items: flex-start;
    padding: 0.75rem 0.9rem;
    font-size: 0.78rem;
    color: var(--dim);
    cursor: pointer;
    background: rgba(255,255,255,0.02);
  }
  .chevron {
    display: inline-block;
    width: 0.6em;
    height: 0.6em;
    flex-shrink: 0;
    transition: transform 0.12s;
    vertical-align: -0.05em;
  }
  .risky-header .chevron { margin-top: 0.15rem; }
  .risky-header.expanded .chevron { transform: rotate(90deg); }
  .risky-header strong { color: var(--text); }
  .risky-list { padding: 0.25rem 0.9rem 0.75rem; border-top: 1px solid var(--border); }
  .risky-controls { display: flex; gap: 0.5rem; padding: 0.6rem 0; }
  .risky-controls button {
    background: none;
    border: 1px solid var(--border);
    color: var(--text);
    border-radius: 6px;
    padding: 0.3rem 0.7rem;
    font-size: 0.75rem;
    cursor: pointer;
  }
  .risky-controls button:hover { border-color: var(--accent); color: var(--accent); }
  .risky-item {
    display: flex;
    gap: 0.6rem;
    align-items: flex-start;
    padding: 0.6rem 0;
    border-bottom: 1px solid var(--border);
    font-size: 0.78rem;
    cursor: pointer;
  }
  .risky-item:last-child { border-bottom: none; }
  .risky-item input { margin-top: 0.2rem; flex-shrink: 0; }
  .risky-item .rule-id { font-family: var(--mono); color: var(--accent); }
  .risky-item .rule-blurb { color: var(--dim); margin-top: 0.15rem; }
  .vid-toggle { cursor: pointer; user-select: none; }
  .vid-toggle:hover { text-decoration: underline; }
  .vid-toggle .chevron { margin-right: 0.35rem; }
  .vid-toggle.expanded .chevron { transform: rotate(90deg); }
  .device-head { cursor: pointer; user-select: none; }
  .subhead.section-toggle { cursor: pointer; user-select: none; }
  .section-toggle .chevron, .device-head .chevron { margin-right: 0.4rem; }
  .section-toggle.expanded .chevron, .device-head.expanded .chevron { transform: rotate(90deg); }
  .section-note { font-size: 0.75rem; color: var(--dim); font-style: italic; margin: 0.4rem 0; }
  .no-evidence-list {
    margin: 0.4rem 0 0.5rem;
    padding-left: 1.2rem;
    font-size: 0.78rem;
    color: var(--dim);
  }
  .no-evidence-list li { padding: 0.15rem 0; }
  .results-toolbar {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 1rem;
    padding: 0.6rem 0.9rem;
    margin: 0.75rem 0;
    border: 1px solid var(--border);
    border-radius: 8px;
    font-size: 0.78rem;
    color: var(--dim);
  }
  .results-toolbar label { display: flex; align-items: center; gap: 0.4rem; }
  .results-toolbar select {
    background: var(--bg);
    color: var(--text);
    border: 1px solid var(--border);
    border-radius: 6px;
    padding: 0.25rem 0.5rem;
    font-size: 0.78rem;
    font-family: inherit;
  }
  .results-toolbar select:hover { border-color: var(--accent); }
  .toolbar-btn {
    background: none;
    border: 1px solid var(--border);
    color: var(--text);
    border-radius: 6px;
    padding: 0.3rem 0.7rem;
    font-size: 0.75rem;
    cursor: pointer;
  }
  .toolbar-btn:hover { border-color: var(--accent); color: var(--accent); }
  .self-test-panel {
    margin-top: 1.5rem;
    padding-top: 1rem;
    border-top: 1px solid var(--border);
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 0.75rem;
  }
  .self-test-version { font-size: 0.72rem; color: var(--dim); font-family: var(--mono); }
  #selfTestResults {
    flex-basis: 100%;
    margin-top: 0.5rem;
    border: 1px solid var(--border);
    border-radius: 8px;
    padding: 0.75rem 1rem;
    font-size: 0.78rem;
  }
  .self-test-summary { font-weight: 600; margin-bottom: 0.5rem; }
  .self-test-summary.all-pass { color: #4caf50; }
  .self-test-summary.has-fail { color: var(--open); }
  .self-test-row {
    display: flex;
    gap: 0.6rem;
    align-items: baseline;
    padding: 0.3rem 0;
    border-bottom: 1px solid var(--border);
  }
  .self-test-row:last-child { border-bottom: none; }
  .self-test-row .st-mark { flex-shrink: 0; width: 1.2em; }
  .self-test-row.pass .st-mark { color: #4caf50; }
  .self-test-row.fail .st-mark { color: var(--open); }
  .self-test-row .st-name { color: var(--text); }
  .self-test-row .st-rule { color: var(--dim); font-family: var(--mono); font-size: 0.72rem; }
  .self-test-row .st-detail { color: var(--dim); font-size: 0.72rem; flex-basis: 100%; padding-left: 1.8em; }
  .toolbar-note { color: var(--dim); font-style: italic; }
  .device-block.filtered-empty { display: none; }
  .load-error-detail {
    background: rgba(224, 108, 108, 0.08);
    border: 1px solid var(--open);
    border-radius: 6px;
    padding: 0.7rem 0.9rem;
    font-size: 0.8rem;
    color: var(--text);
    margin-bottom: 0.5rem;
  }
  .paste-toggle {
    display: flex; align-items: center;
    font-size: 0.82rem; color: var(--dim);
    margin-top: 0.75rem;
  }
  .paste-toggle:hover { color: var(--accent); }
  .paste-panel { margin-top: 0.6rem; }
  .paste-panel input[type="text"], .paste-panel textarea {
    width: 100%;
    box-sizing: border-box;
    background: var(--bg);
    color: var(--text);
    border: 1px solid var(--border);
    border-radius: 6px;
    padding: 0.55rem 0.7rem;
    font-size: 0.82rem;
    font-family: var(--mono);
    margin-bottom: 0.5rem;
  }
  .paste-panel textarea { resize: vertical; min-height: 120px; }
  .paste-panel input[type="text"]:focus, .paste-panel textarea:focus {
    outline: none; border-color: var(--accent);
  }
  .paste-controls { display: flex; gap: 0.5rem; }
  .paste-controls button {
    background: none;
    border: 1px solid var(--border);
    color: var(--text);
    border-radius: 6px;
    padding: 0.4rem 0.8rem;
    font-size: 0.78rem;
    cursor: pointer;
  }
  .paste-controls button:hover { border-color: var(--accent); color: var(--accent); }
  #addPastedConfigBtn { border-color: var(--accent); color: var(--accent); }
  .possible-matches-toggle {
    display: flex; align-items: center; gap: 0.5rem;
    font-size: 0.78rem; color: var(--dim);
    margin: 0.5rem 0 0.75rem;
    cursor: pointer; user-select: none;
  }
  .possible-matches-toggle input { flex-shrink: 0; }
  .status.manual-off { color: var(--dim); }
  .detail-row td {
    background: rgba(255,255,255,0.02);
    font-size: 0.78rem;
    padding: 0.8rem 1rem;
  }
  .detail-row dl { margin: 0; }
  .detail-row dt {
    font-size: 0.68rem;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    color: var(--dim);
    margin-top: 0.7rem;
  }
  .detail-row dt:first-child { margin-top: 0; }
  .detail-row dd {
    margin: 0.2rem 0 0;
    color: var(--text);
    white-space: pre-wrap;
    font-family: var(--mono);
    font-size: 0.76rem;
    line-height: 1.4;
  }
</style>
</head>
<body>
<div class="wrap">
  <h1>CKLB Auto-Fill (Bulk)</h1>
  <p class="subtitle" id="subtitleText">Cisco IOS Switch NDM STIG — one template checklist, any number of device configs, matched against rule checks entirely in your browser. Nothing is uploaded anywhere.</p>

  <div class="card">
    <h2>1. Template .cklb (used as the starting point for every device)</h2>
    <div class="drop" id="dropCklb">
      <div>Click to choose, or drag a .cklb file here</div>
      <div class="filename" id="nameCklb"></div>
      <input type="file" id="fileCklb" accept=".cklb,application/json">
    </div>
  </div>

  <div class="card">
    <h2>2. Device running-configs (.txt) — one or many</h2>
    <div class="drop" id="dropCfg">
      <div>Click to choose, or drag one or more config text files here</div>
      <div class="filename" id="nameCfg"></div>
      <input type="file" id="fileCfg" accept=".txt,.cfg,.log,text/plain" multiple>
    </div>
    <div class="rules-banner hidden" id="cfgWarning" style="margin-top:0.75rem;"></div>

    <div class="section-toggle paste-toggle" id="pasteToggle">
      <svg class="chevron" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M5 2l7 6-7 6V2z"/></svg><span>Or paste config text instead</span>
    </div>
    <div class="paste-panel hidden" id="pastePanel">
      <input type="text" id="pasteConfigName" placeholder="Optional label (e.g. SW01.cfg) - a name is generated if left blank">
      <textarea id="pasteConfigText" rows="8" placeholder="Paste the device running-config here..."></textarea>
      <div class="paste-controls">
        <button type="button" id="addPastedConfigBtn">Add pasted config</button>
        <button type="button" id="clearConfigsBtn">Clear all loaded configs</button>
      </div>
    </div>
  </div>

  <div class="risky-panel">
    <div class="risky-header" id="riskyHeader">
      <svg class="chevron" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M5 2l7 6-7 6V2z"/></svg>
      <span><strong>Uncertain checks</strong> — <span id="riskyCountText">8 checks</span> have known blind spots (shown below). <strong>All off by default</strong> - each one falls back to manual review with evidence shown unless you explicitly enable it, having judged the trade-off acceptable for your environment.</span>
    </div>
    <div class="risky-list hidden" id="riskyList">
      <div class="risky-controls">
        <button type="button" id="riskyEnableAll">Enable all</button>
        <button type="button" id="riskyDisableAll">Disable all</button>
      </div>
      <div id="riskyItems"></div>
    </div>
  </div>

  <button class="run" id="runBtn" disabled>Run checks</button>

  <label class="possible-matches-toggle" for="possibleMatchesToggle">
    <input type="checkbox" id="possibleMatchesToggle" checked>
    Search not-automated rules for possible matching config lines (shown as informational context, never as a finding)
  </label>

  <div id="results" class="hidden">
    <div class="card">
      <h2>Results</h2>
      <div class="summary">
        <div class="stat"><div class="n" id="statDevices">0</div><div class="l">Devices</div></div>
        <div class="stat"><div class="n" id="statFilled">0</div><div class="l">Automated results (total)</div></div>
        <div class="stat ok"><div class="n" id="statNA">0</div><div class="l">Not a finding (total)</div></div>
        <div class="stat open"><div class="n" id="statOpen">0</div><div class="l">Open (total)</div></div>
        <div class="stat manual"><div class="n" id="statManual">0</div><div class="l">Manual review (total)</div></div>
        <div class="stat manual"><div class="n" id="statNotAutomated">0</div><div class="l">Not automated (total)</div></div>
        <div class="stat error hidden" id="statErrorWrap"><div class="n" id="statErrors">0</div><div class="l">Automation errors</div></div>
      </div>
      <div class="rules-banner hidden" id="errorBanner" style="border-color: var(--open); color: var(--open); font-weight: 700;"></div>
      <div class="rules-banner" id="rulesBanner"></div>
      <div class="results-toolbar hidden" id="resultsToolbar">
        <label>Show:
          <select id="statusFilter">
            <option value="all">All statuses</option>
            <option value="open">Open only</option>
            <option value="manual">Manual review only</option>
            <option value="not_a_finding">Not a finding only</option>
            <option value="not_applicable">Not applicable only</option>
            <option value="error">Automation errors only</option>
          </select>
        </label>
        <label>Sort devices by:
          <select id="deviceSort">
            <option value="name">Name (A–Z)</option>
            <option value="open_desc">Most Open first</option>
            <option value="manual_desc">Most Manual Review first</option>
            <option value="notautomated_desc">Most Not Automated first</option>
            <option value="errors_desc">Most Automation Errors first</option>
          </select>
        </label>
        <button type="button" class="toolbar-btn" id="expandAllBtn">Expand all</button>
        <button type="button" class="toolbar-btn" id="collapseAllBtn">Collapse all</button>
        <span class="toolbar-note" id="filterNote"></span>
      </div>
      <div id="deviceTables"></div>
      <a class="download hidden" id="downloadLink">Download filled .cklb files (.zip)</a>
    </div>
  </div>

  <div class="note">
    Every rule in the loaded cklb gets either a confident pass/fail, a "Manual Review" verdict with evidence attached, or is left fully untouched for genuine human judgment (the exact split is shown live above after you run - it depends on which STIG you load and which "Uncertain checks" you enable). Click any V-ID to see that rule's full title, discussion, check text, and fix text. Uncertain checks (panel above, all off by default) force-adjudicate a known-imperfect subset using bare presence/absence only - enable individually only where you've judged the trade-off acceptable for your environment. Always spot-check auto-filled results before submitting. Each device's output is named after its <code>hostname</code> line if found, otherwise after the config file's own name, and gets its own freshly generated checklist ID.
  </div>

  <div class="self-test-panel">
    <button type="button" class="toolbar-btn" id="runSelfTestsBtn">Run self-tests</button>
    <span class="self-test-version">Tool v<span id="selfTestVersion"></span></span>
    <div id="selfTestResults" class="hidden"></div>
  </div>
</div>

<script>
(function () {
  "use strict";

  let cklbTemplateData = null;
  let cklbTemplateText = null;
  let configFiles = []; // [{name, text}]

  const TOOL_VERSION = "2.0";

  // Shared expand/collapse chevron icon, used everywhere a section or row
  // can be toggled. An inline SVG rather than a Unicode glyph (e.g. ▸) -
  // triangle glyphs render inconsistently (sometimes as a tiny dot) across
  // fonts/OSes, especially at small sizes; an SVG path always renders the
  // same everywhere.
  const CHEVRON_SVG = '<svg class="chevron" viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M5 2l7 6-7 6V2z"/></svg>';

  // -------------------------------------------------------------------
  // Filename safety - never trust config-derived text (hostname) blindly
  // as a filesystem name.
  // -------------------------------------------------------------------
  function sanitizeFilename(name) {
    const cleaned = String(name || "")
      .replace(/[<>:"/\\|?*\x00-\x1F]/g, "_")
      .replace(/[. ]+$/, "")
      .trim();
    return cleaned || "device";
  }

  // -------------------------------------------------------------------
  // Basic structural validation so a malformed/unrelated JSON file can't
  // get as far as "Run checks" and produce confusing runtime behavior.
  // -------------------------------------------------------------------
  function validateCklbStructure(data) {
    if (!data || typeof data !== "object" || Array.isArray(data)) {
      return "The file's root is not a JSON object.";
    }
    if (!Array.isArray(data.stigs)) {
      return "Missing or invalid 'stigs' array - this doesn't look like a .cklb checklist.";
    }
    for (const stig of data.stigs) {
      if (!stig || !Array.isArray(stig.rules)) {
        return "A STIG entry is missing its 'rules' array.";
      }
      for (const rule of stig.rules) {
        if (!rule || typeof rule !== "object") {
          return "A rule entry is not an object.";
        }
        if (!rule.rule_version || !rule.group_id || !("status" in rule)) {
          return `A rule is missing a required field (rule_version/group_id/status) near group_id=${rule.group_id || "unknown"}.`;
        }
      }
    }
    return null; // structurally OK
  }

  // -------------------------------------------------------------------
  // Loose heuristic so a non-config text dump (or a "show running-config |
  // section ..." fragment) doesn't get silently graded as if it were a
  // full Cisco IOS running-config. Non-blocking - just a warning.
  // -------------------------------------------------------------------
  function looksLikeCiscoConfig(text) {
    const signals = [
      /^hostname\s+\S+/im,
      /^version\s+\d/im,
      /^!\s*$/m,
      /^interface\s+\S+/im,
      /^line\s+(con|vty|aux)\b/im
    ];
    const hits = signals.filter(re => re.test(text)).length;
    return hits >= 2;
  }

  // -------------------------------------------------------------------
  // File pickers (click + drag/drop)
  // -------------------------------------------------------------------
  function wireDropSingle(dropId, inputId, nameId, onLoad) {
    const drop = document.getElementById(dropId);
    const input = document.getElementById(inputId);
    const nameEl = document.getElementById(nameId);

    drop.addEventListener("click", () => { input.value = ""; input.click(); });
    input.addEventListener("change", (e) => {
      if (e.target.files.length) handleFile(e.target.files[0]);
    });
    drop.addEventListener("dragover", (e) => { e.preventDefault(); drop.classList.add("drag"); });
    drop.addEventListener("dragleave", () => drop.classList.remove("drag"));
    drop.addEventListener("drop", (e) => {
      e.preventDefault();
      drop.classList.remove("drag");
      if (e.dataTransfer.files.length) handleFile(e.dataTransfer.files[0]);
    });

    function handleFile(file) {
      nameEl.textContent = file.name;
      const reader = new FileReader();
      reader.onload = (ev) => onLoad(ev.target.result, file.name);
      reader.onerror = () => {
        alert(`Could not read "${file.name}": ${reader.error ? reader.error.message : "unknown file read error"}. Please try again or choose a different file.`);
        nameEl.textContent = "";
      };
      reader.readAsText(file, "UTF-8");
    }
  }

  function wireDropMulti(dropId, inputId, nameId, onLoad) {
    const drop = document.getElementById(dropId);
    const input = document.getElementById(inputId);
    const nameEl = document.getElementById(nameId);

    drop.addEventListener("click", () => { input.value = ""; input.click(); });
    input.addEventListener("change", (e) => {
      if (e.target.files.length) handleFiles(e.target.files);
    });
    drop.addEventListener("dragover", (e) => { e.preventDefault(); drop.classList.add("drag"); });
    drop.addEventListener("dragleave", () => drop.classList.remove("drag"));
    drop.addEventListener("drop", (e) => {
      e.preventDefault();
      drop.classList.remove("drag");
      if (e.dataTransfer.files.length) handleFiles(e.dataTransfer.files);
    });

    function handleFiles(fileList) {
      const files = Array.from(fileList);
      nameEl.textContent = files.length === 1 ? files[0].name : `${files.length} files selected`;
      let remaining = files.length;
      const loaded = [];
      const failed = [];
      files.forEach(file => {
        const reader = new FileReader();
        reader.onload = (ev) => {
          loaded.push({ name: file.name, text: ev.target.result });
          remaining--;
          if (remaining === 0) finish();
        };
        reader.onerror = () => {
          failed.push(file.name);
          remaining--;
          if (remaining === 0) finish();
        };
        reader.readAsText(file, "UTF-8");
      });
      function finish() {
        if (failed.length) {
          alert(`Could not read ${failed.length} file(s): ${failed.join(", ")}. The remaining ${loaded.length} file(s) loaded fine and will still be processed.`);
        }
        if (loaded.length) onLoad(loaded);
      }
    }
  }

  wireDropSingle("dropCklb", "fileCklb", "nameCklb", (text, fname) => {
    let parsed;
    try {
      parsed = JSON.parse(text);
    } catch (err) {
      alert("Could not parse that as JSON: " + err.message);
      cklbTemplateData = null;
      checkReady();
      return;
    }
    const structureError = validateCklbStructure(parsed);
    if (structureError) {
      alert("Invalid CKLB structure: " + structureError);
      cklbTemplateData = null;
      checkReady();
      return;
    }
    cklbTemplateData = parsed;
    cklbTemplateText = text;
    renderRiskyItems(); // re-render with real V-IDs now that a template is loaded
    checkReady();
  });

  const cfgWarningEl = document.getElementById("cfgWarning");
  const nameCfgEl = document.getElementById("nameCfg");

  // Shared by both the file-drop path and the paste-config path, so the
  // warning banner, filename summary, and Run-button enablement always
  // reflect the full, current configFiles list regardless of which input
  // method added to it.
  function refreshConfigFilesUI() {
    nameCfgEl.textContent = configFiles.length === 0 ? ""
      : configFiles.length === 1 ? configFiles[0].name
      : `${configFiles.length} config(s) loaded`;
    const suspicious = configFiles.filter(f => !looksLikeCiscoConfig(f.text)).map(f => f.name);
    if (cfgWarningEl) {
      if (suspicious.length > 0) {
        cfgWarningEl.classList.remove("hidden");
        cfgWarningEl.innerHTML = `⚠ ${suspicious.length} file(s) don't look like a Cisco IOS running-config (${escapeHtml(suspicious.join(", "))}). Checks will still run, but results for these may be unreliable.`;
      } else {
        cfgWarningEl.classList.add("hidden");
        cfgWarningEl.innerHTML = "";
      }
    }
    checkReady();
  }

  wireDropMulti("dropCfg", "fileCfg", "nameCfg", (files) => {
    // A new file selection REPLACES the set (matches how a native file
    // input behaves - re-picking files doesn't add to the old picks).
    // Pasted configs are additive instead; see addPastedConfigBtn below.
    configFiles = files;
    refreshConfigFilesUI();
  });

  // -------------------------------------------------------------------
  // Paste-config alternative to file upload - useful for a quick one-off
  // check without saving a file first. Additive: each "Add pasted config"
  // click appends one more entry to configFiles alongside anything already
  // loaded (via upload or a previous paste).
  // -------------------------------------------------------------------
  const pasteToggle = document.getElementById("pasteToggle");
  const pastePanel = document.getElementById("pastePanel");
  pasteToggle.addEventListener("click", () => {
    pastePanel.classList.toggle("hidden");
    pasteToggle.classList.toggle("expanded");
  });

  let pastedConfigCounter = 0;
  document.getElementById("addPastedConfigBtn").addEventListener("click", () => {
    const textEl = document.getElementById("pasteConfigText");
    const nameEl = document.getElementById("pasteConfigName");
    const text = textEl.value;
    if (!text.trim()) {
      alert("Paste some config text first.");
      return;
    }
    pastedConfigCounter++;
    const name = nameEl.value.trim() || `pasted-config-${pastedConfigCounter}.cfg`;
    configFiles = [...configFiles, { name, text }];
    refreshConfigFilesUI();
    textEl.value = "";
    nameEl.value = "";
  });

  document.getElementById("clearConfigsBtn").addEventListener("click", () => {
    configFiles = [];
    document.getElementById("fileCfg").value = "";
    refreshConfigFilesUI();
  });

  function checkReady() {
    document.getElementById("runBtn").disabled = !(cklbTemplateData && configFiles.length);
  }

  // -------------------------------------------------------------------
  // Per-rule opt-out for checks with known blind spots. All run by default
  // (matching prior behavior); unchecking one makes that rule fall through
  // to the same generic manual-evidence bucket as the fully-manual rules,
  // instead of being auto-adjudicated by its RULE_CHECKS entry.
  // -------------------------------------------------------------------
  // Rules removed from this list over time (000010, 000490) had their
  // underlying blind spot fixed directly in RULE_CHECKS instead - e.g.
  // real line-block parsing, or falling back to "manual" instead of a
  // false "Open" when the config is genuinely ambiguous. 000720/001200/
  // 001210 are (back) in this list because each has a piece whose
  // enabled/disabled DEFAULT state can't be proven from a static config
  // file - only from live device state ('show ip http server status',
  // 'show ip ssh') - so absence of an explicit command defers to manual
  // review there rather than being auto-failed or auto-passed.
  const RISKY_RULES = [
    {
      id: "CISC-ND-000620",
      label: "Password Encryption Hash Type",
      blurb: "This rule's own check text uses Type 5 (MD5) as its example, so the checker does not fail on Type 5 - that's intentional, not a gap. Enabling this just means you additionally want the hash type (5 vs 8/9) surfaced as informational evidence rather than left for manual review; it doesn't change what counts as compliant."
    },
    {
      id: "CISC-ND-000720",
      label: "Session Timeout (line exec-timeout + HTTP)",
      blurb: "Line con/vty exec-timeout is checked deterministically, but the HTTP/HTTPS 'ip http timeout-policy' half of this rule can only be evaluated when the config explicitly enables OR explicitly fully disables ('no ip http server' AND 'no ip http secure-server') management HTTP/HTTPS - if neither is explicit, whether the requirement even applies can't be proven from a static file, so that piece defers to manual review."
    },
    {
      id: "CISC-ND-001030",
      label: "NTP Redundancy",
      blurb: "Parses vrf-scoped, IPv6, and keyed 'ntp server' lines, but still can't verify the servers are reachable, correctly routed, or that an address isn't simply invalid/typo'd - that requires live device state this tool doesn't have."
    },
    {
      id: "CISC-ND-001200",
      label: "SSH MAC Algorithms",
      blurb: "Both the 'ip ssh version 2' precondition and the MAC-algorithm restriction only ever auto-fail on an explicit weak setting - their absence defers to manual review instead, since modern IOS-XE defaults to SSHv2 with a secure MAC set whether or not either command appears in the file, and confirming that really requires 'show ip ssh' on the live device."
    },
    {
      id: "CISC-ND-001210",
      label: "SSH Encryption Algorithms",
      blurb: "Same reasoning as the MAC check above - absence of an explicit 'ip ssh version 2' or 'ip ssh server algorithm encryption' line defers to manual review rather than an automatic Open, since secure defaults on modern IOS-XE can't be confirmed from a static config file."
    },
    {
      id: "CISC-ND-001450",
      label: "Syslog Servers",
      blurb: "Regex covers 'logging host <ip>' (including vrf-scoped) and bare 'logging <ip>' formats, IPv6 addresses, and FQDN hostnames. Still can't rule out an unusual Cisco syntax variant this pattern doesn't anticipate - a compliant device using such a form could be falsely flagged as Open."
    }
  ];

  const riskyHeader = document.getElementById("riskyHeader");
  const riskyList = document.getElementById("riskyList");
  const riskyItems = document.getElementById("riskyItems");

  // Resolves which risky-rule list applies (switch, router, or both, if a
  // template somehow bundles STIGs for more than one platform) and each
  // rule's real V-ID from the loaded template, if one is loaded yet.
  //
  // IMPORTANT: this must not reference ROUTER_RISKY_RULES/
  // detectPlatformForStig/getRiskyRulesForPlatform outside the
  // `cklbTemplateData` guard below - those are declared later in this
  // script (after RULE_CHECKS), and renderRiskyItems() is called once,
  // immediately, before any template is loaded and before that later code
  // has executed. Since cklbTemplateData is null at that first call, the
  // guarded branch never runs then, so the not-yet-declared names are
  // never touched - avoiding a temporal-dead-zone crash on page load.
  function getActiveRiskyRulesAndVidLookup() {
    let vidLookup = {};
    let activeRules = RISKY_RULES; // switch-only default before any template loads
    if (cklbTemplateData) {
      const platforms = new Set();
      (cklbTemplateData.stigs || []).forEach(stig => {
        platforms.add(detectPlatformForStig(stig));
        (stig.rules || []).forEach(rule => { vidLookup[rule.rule_version] = rule.group_id; });
      });
      const seen = new Set();
      activeRules = [];
      platforms.forEach(p => {
        getRiskyRulesForPlatform(p).forEach(r => {
          if (!seen.has(r.id)) { seen.add(r.id); activeRules.push(r); }
        });
      });
    }
    return { activeRules, vidLookup };
  }

  function renderRiskyItems() {
    const { activeRules, vidLookup } = getActiveRiskyRulesAndVidLookup();
    riskyItems.innerHTML = activeRules.map(r => `
      <label class="risky-item">
        <input type="checkbox" data-risky-id="${r.id}">
        <div>
          <span class="rule-id">${escapeHtml(vidLookup[r.id] || r.id)}</span> — <strong>Enable automated adjudication: ${escapeHtml(r.label)}</strong>
          <div class="rule-blurb">⚠ Known limitation: ${escapeHtml(r.blurb)}</div>
        </div>
      </label>
    `).join("");
    document.getElementById("riskyCountText").textContent = activeRules.length + " checks";
  }
  renderRiskyItems();

  riskyHeader.addEventListener("click", () => {
    riskyList.classList.toggle("hidden");
    riskyHeader.classList.toggle("expanded");
  });
  document.getElementById("riskyEnableAll").addEventListener("click", () => {
    document.querySelectorAll("#riskyItems input[type=checkbox]").forEach(cb => cb.checked = true);
  });
  document.getElementById("riskyDisableAll").addEventListener("click", () => {
    document.querySelectorAll("#riskyItems input[type=checkbox]").forEach(cb => cb.checked = false);
  });

  function getDisabledRiskyKeys() {
    const disabled = new Set();
    document.querySelectorAll("#riskyItems input[type=checkbox]").forEach(cb => {
      if (!cb.checked) disabled.add(cb.getAttribute("data-risky-id"));
    });
    return disabled;
  }

  // -------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------
  function getCcPolicyBlock(cfg) {
    const m = cfg.match(/^aaa common-criteria policy\s+\S+\s*\r?\n([\s\S]*?)(?=^!)/m);
    return m ? m[1] : null;
  }

  function getDeviceName(cfg, fallback) {
    const m = cfg.match(/^hostname\s+(\S+)/im);
    return m ? m[1] : fallback;
  }

  function allMatches(text, re) {
    // re must have the global flag
    const out = [];
    let m;
    const r = new RegExp(re.source, re.flags.includes("g") ? re.flags : re.flags + "g");
    while ((m = r.exec(text)) !== null) {
      out.push(m);
      if (m.index === r.lastIndex) r.lastIndex++; // guard zero-length matches
    }
    return out;
  }

  // -------------------------------------------------------------------
  // Generic IOS config-block parser. Understands that "line con 0",
  // "line vty 0 4", "line vty 5 15", etc. are indented sub-blocks that end
  // at the next block header, a bare "!", or any other unindented line -
  // rather than relying on a single regex's lookahead to guess where a
  // block stops. Shared by every check that needs to reason about line
  // context specifically instead of "does this string appear anywhere".
  // -------------------------------------------------------------------
  function parseConfigBlocks(cfg, headerRegex) {
    const lines = cfg.split(/\r?\n/);
    const blocks = [];
    let current = null;
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      if (headerRegex.test(line)) {
        if (current) blocks.push(current);
        current = { header: line.trim(), lines: [] };
        continue;
      }
      if (current) {
        if (/^!\s*$/.test(line)) {
          blocks.push(current);
          current = null;
          continue;
        }
        if (/^\S/.test(line)) {
          // Any other unindented line implicitly closes a line/interface
          // sub-block, since Cisco IOS always indents block bodies.
          blocks.push(current);
          current = null;
          continue;
        }
        current.lines.push(line);
      }
    }
    if (current) blocks.push(current);
    return blocks;
  }

  function parseLineBlocks(cfg) {
    return parseConfigBlocks(cfg, /^line\s+(con|vty|aux|tty)\s+\S+/i);
  }

  // -------------------------------------------------------------------
  // NTP server line parser - handles vrf-scoped, IPv6, and keyed forms,
  // e.g.: "ntp server 10.1.1.1", "ntp server vrf MGMT 10.1.1.3",
  // "ntp server 2001:db8::1", "ntp server 10.1.1.1 key 5",
  // "ntp server 10.1.1.1 source Loopback0".
  // -------------------------------------------------------------------
  function parseNtpServers(cfg) {
    const raw = allMatches(cfg, /^ntp server\s+(?:vrf\s+(\S+)\s+)?(\S+)(.*)$/im);
    return raw.map(m => {
      const rest = m[3] || "";
      const keyMatch = rest.match(/\bkey\s+(\d+)/i);
      const sourceMatch = rest.match(/\bsource\s+(\S+)/i);
      return {
        raw: m[0].trim(),
        vrf: m[1] || null,
        address: m[2],
        key: keyMatch ? keyMatch[1] : null,
        source: sourceMatch ? sourceMatch[1] : null
      };
    });
  }

  // -------------------------------------------------------------------
  // TACACS+/RADIUS server parser - Cisco IOS/IOS-XE supports THREE
  // unrelated syntaxes for defining the same thing, and a device can use
  // any one of them (or a mix):
  //   Legacy:   "tacacs-server host 10.1.1.1" / "radius-server host 10.1.1.1"
  //   Modern:   "tacacs server NAME" / "radius server NAME" block containing
  //             an indented "address ipv4 10.1.1.1" (or ipv6) line.
  //   Grouped:  "aaa group server tacacs+ NAME" / "aaa group server radius
  //             NAME" block containing one or more indented
  //             "server-private 10.1.1.1 ..." lines - each is its own
  //             server entry, and a single group commonly lists several.
  // Recognizing only the legacy form (as an earlier version of this tool
  // did) meant a device using the modern block syntax - or this grouped
  // "server-private" form - was counted as having ZERO servers of that
  // type. All three are normalized into the same {address, raw} shape and
  // de-duplicated by address so counting redundancy is syntax-agnostic.
  // -------------------------------------------------------------------
  function parseAaaServers(cfg, kind) {
    // kind: "tacacs" or "radius"
    const results = [];
    const legacyRe = kind === "tacacs"
      ? /^tacacs-server host\s+(\S+)/im
      : /^radius-server host\s+(\S+)/im;
    allMatches(cfg, legacyRe).forEach(m => {
      results.push({ address: m[1], raw: m[0].trim() });
    });

    const headerRe = kind === "tacacs" ? /^tacacs server\s+\S+/i : /^radius server\s+\S+/i;
    parseConfigBlocks(cfg, headerRe).forEach(b => {
      const body = b.lines.join("\n");
      const am = body.match(/^\s*address\s+ipv[46]\s+(\S+)/im);
      results.push({
        address: am ? am[1] : null,
        raw: am ? `${b.header} (address ${am[1]})` : `${b.header} (no address line found)`
      });
    });

    const groupHeaderRe = kind === "tacacs"
      ? /^aaa group server tacacs\+?\s+\S+/i
      : /^aaa group server radius\s+\S+/i;
    parseConfigBlocks(cfg, groupHeaderRe).forEach(b => {
      const body = b.lines.join("\n");
      allMatches(body, /^\s*server-private\s+(\S+)/im).forEach(m => {
        results.push({ address: m[1], raw: `${b.header}: server-private ${m[1]}` });
      });
    });

    return results;
  }

  // -------------------------------------------------------------------
  // Custom-named AAA server-group resolver. "aaa authentication login ...
  // group CorpAAA" can reference a group whose NAME has nothing to do with
  // "tacacs"/"radius" - its actual server type is only declared on its own
  // "aaa group server tacacs+|radius CorpAAA" header line. Without this,
  // a login line referencing a custom-named group wouldn't be recognized
  // as using TACACS+/RADIUS at all, even though it demonstrably is.
  // -------------------------------------------------------------------
  function parseAaaGroups(cfg) {
    const map = new Map(); // lowercased group name -> { type, servers: [{address, raw}] }
    parseConfigBlocks(cfg, /^aaa group server (tacacs\+?|radius)\s+\S+/i).forEach(b => {
      const hm = b.header.match(/^aaa group server (tacacs\+?|radius)\s+(\S+)/i);
      if (!hm) return;
      const type = hm[1].toLowerCase().replace("+", "");
      const name = hm[2];
      const body = b.lines.join("\n");
      const servers = allMatches(body, /^\s*server-private\s+(\S+)/im).map(m => ({ address: m[1], raw: `${b.header}: server-private ${m[1]}` }));
      map.set(name.toLowerCase(), { type, servers });
    });
    return map;
  }

  // -------------------------------------------------------------------
  // Requirement tables - keep the numeric thresholds DISA's STIG mandates
  // as data, not buried inside a function body, so a future STIG revision
  // is a one-line edit instead of a code hunt.
  // -------------------------------------------------------------------
  const REQUIREMENTS = {
    "CISC-ND-000150": { maxAttempts: 3 },
    // No specific numeric ceiling is stated in this rule's own check text
    // for session-limit - only "some restriction must exist". Leave null
    // rather than inventing a number; the checker surfaces the configured
    // value for manual sanity-check instead of silently enforcing a made-up
    // threshold. Set a number here if your org's policy defines one.
    "CISC-ND-000010": { maxSessionLimit: null }
  };

  const CC_REQUIREMENTS = {
    "CISC-ND-000550": { key: "min-length", min: 15 },
    "CISC-ND-000570": { key: "upper-case", min: 1 },
    "CISC-ND-000580": { key: "lower-case", min: 1 },
    "CISC-ND-000590": { key: "numeric-count", min: 1 },
    "CISC-ND-000600": { key: "special-case", min: 1 },
    "CISC-ND-000610": { key: "char-changes", min: 8 }
  };

  // -------------------------------------------------------------------
  // Rule-specific adjudication rationale, kept as data rather than buried
  // in inline comments inside a rule function - makes it possible to
  // surface "why did this pass despite looking weak" directly wherever a
  // reviewer is looking (currently used to build the informational note
  // in 000620's evidence), without duplicating the explanation in code
  // comments that a UI can't reach.
  // -------------------------------------------------------------------
  const RULE_METADATA = {
    "CISC-ND-000620": {
      rationale: "This rule's own check text uses Type 5 (MD5-based 'enable secret 5 ...') as its example, so a Type 5 hash is not treated as a failure here - that would enforce a stricter requirement than the rule itself states. Type 8/9 (SHA-256) is stronger and worth migrating to, but the hash type is surfaced as informational evidence only; it does not change the verdict."
    }
  };

  // -------------------------------------------------------------------
  // Services/daemons this NDM STIG's unnecessary-services rule prohibits.
  // Kept as a data table (with a pointer back to the rule ID whose loaded
  // check_content it should be cross-checked against) rather than a bare
  // array, since a STIG revision to this list should be a data edit, not
  // an archaeology exercise through a regex filter.
  // -------------------------------------------------------------------
  const PROHIBITED_SERVICES = {
    ruleId: "CISC-ND-000470",
    services: ["boot network", "ip boot server", "ip bootp server", "ip dns server",
      "ip identd", "ip finger", "ip http server", "ip rcmd rcp-enable",
      "ip rcmd rsh-enable", "service config", "service finger",
      "service tcp-small-servers", "service udp-small-servers"]
  };

  // -------------------------------------------------------------------
  // Single internal result vocabulary. Every RULE_CHECKS function may
  // still return either the legacy {match: boolean} shape or the newer
  // {status: "pass"|"fail"|"manual"|"not_applicable"} shape - this
  // normalizes either into one contract and throws a loud, visible
  // automation error (rather than silently misbehaving) if a checker
  // returns something that matches neither.
  // -------------------------------------------------------------------
  const VALID_STATUS_KINDS = new Set(["pass", "fail", "manual", "not_applicable"]);

  function normalizeCheckResult(raw) {
    if (raw == null) return null;
    let statusKind;
    if (raw.status === "manual" || raw.status === "not_applicable" ||
        raw.status === "pass" || raw.status === "fail") {
      statusKind = raw.status;
    } else if (typeof raw.match === "boolean") {
      statusKind = raw.match ? "pass" : "fail";
    } else {
      throw new Error("Malformed check result - expected a 'match' boolean or a valid 'status', got: " + JSON.stringify(raw));
    }
    if (!VALID_STATUS_KINDS.has(statusKind)) {
      throw new Error("Malformed check result - unrecognized status '" + statusKind + "'");
    }
    return {
      statusKind,
      confidence: raw.confidence || null,
      detail: raw.detail || "",
      evidence: Array.isArray(raw.evidence) ? raw.evidence : []
    };
  }

  // -------------------------------------------------------------------
  // Manual-review evidence extraction — generic across ANY STIG, not just
  // Cisco NDM. Every DISA rule's check_content includes literal example
  // config lines the auditor is told to look for (e.g. "logging trap
  // critical"). For rules we don't auto-adjudicate, pull those example
  // command patterns out and grep the device's actual config for matches,
  // so the reviewer sees relevant lines instead of hunting the full config.
  // This is purely informational and is never written into the exported cklb.
  // -------------------------------------------------------------------
  const NARRATIVE_STARTS = ["verify","note","if ","this is","review","check",
    "confirm","ensure","the ","interview","examine","obtain","when","if,","for "];

  function isConfigLikeLine(line) {
    const t = line.trim();
    if (!t) return false;
    if (t.split(/\s+/).length > 10) return false;
    const low = t.toLowerCase();
    if (NARRATIVE_STARTS.some(s => low.startsWith(s))) return false;
    if (t.endsWith(".") || t.includes("?")) return false;
    return /^[A-Za-z0-9][A-Za-z0-9\-.\/\s#:_]+$/.test(t);
  }

  function extractAnchors(checkContent) {
    if (!checkContent) return [];
    const anchors = [];
    checkContent.split("\n").forEach(line => {
      if (isConfigLikeLine(line)) {
        const words = line.trim().split(/\s+/);
        anchors.push(words.length > 1 ? words.slice(0, 2).join(" ") : words[0]);
      }
    });
    const seen = new Set(), out = [];
    anchors.forEach(a => {
      const key = a.toLowerCase();
      if (!seen.has(key)) { seen.add(key); out.push(a); }
    });
    return out;
  }

  function escapeRegex(s) {
    return s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  }

  function findEvidenceLines(configLines, anchor, maxMatches) {
    // Precompiled per-anchor regex is fine here (anchors are short and few);
    // the real cost was re-splitting the whole config on every call, which
    // the caller now avoids by passing a pre-split line array.
    const re = new RegExp("^\\s*" + escapeRegex(anchor), "i");
    const out = [];
    for (const line of configLines) {
      if (re.test(line)) {
        out.push(line.trim());
        if (out.length >= maxMatches) break;
      }
    }
    return out;
  }

  function buildManualRuleList(cklbTemplate, disabledRiskyKeys) {
    // One-time, config-independent: extract anchors for every rule NOT
    // covered by the correct platform's check table - plus any rule whose
    // entry exists but was disabled via the "uncertain checks" panel,
    // which falls through to this same generic evidence bucket for this
    // run. Platform is resolved per-STIG-block (see detectPlatformForStig)
    // since a single rule_version can mean different things on different
    // platforms.
    const list = [];
    (cklbTemplate.stigs || []).forEach(stig => {
      const table = getRuleCheckTable(detectPlatformForStig(stig));
      (stig.rules || []).forEach(rule => {
        const hasCheck = !!table[rule.rule_version];
        const disabled = disabledRiskyKeys.has(rule.rule_version);
        if (hasCheck && !disabled) return; // auto-filled and enabled, skip
        const anchors = extractAnchors(rule.check_content);
        list.push({
          vid: rule.group_id, title: rule.rule_title, anchors,
          discussion: rule.discussion, checkContent: rule.check_content, fixText: rule.fix_text,
          disabledByToggle: hasCheck && disabled
        });
      });
    });
    return list;
  }

  function gatherEvidenceForDevice(manualRules, configLines, maxLinesPerRule) {
    return manualRules.map(mr => {
      const found = [];
      const seen = new Set();
      mr.anchors.forEach(anchor => {
        findEvidenceLines(configLines, anchor, maxLinesPerRule).forEach(l => {
          if (!seen.has(l)) { seen.add(l); found.push(l); }
        });
      });
      return {
        vid: mr.vid, title: mr.title, lines: found.slice(0, maxLinesPerRule),
        discussion: mr.discussion, checkContent: mr.checkContent, fixText: mr.fixText,
        disabledByToggle: mr.disabledByToggle
      };
    });
  }

  // -------------------------------------------------------------------
  // Rule checks — keyed by the cklb's stable "rule_version" (STIG ID)
  // -------------------------------------------------------------------
  const RULE_CHECKS = {

    "CISC-ND-000010": (cfg) => {
      // Evaluate the restriction inside the actual "line vty" block context,
      // not "does session-limit/transport input none/ip http max-connections
      // appear ANYWHERE in the config" - a session-limit under "line aux 0"
      // used to be able to satisfy this check even with wide-open VTY access.
      const vtyBlocks = parseLineBlocks(cfg).filter(b => /^line\s+vty\b/i.test(b.header));
      const httpMatch = cfg.match(/^ip http max-connections\s+(\d+)/im);
      const httpNote = httpMatch ? ` 'ip http max-connections ${httpMatch[1]}' is also set.` : "";

      if (vtyBlocks.length === 0) {
        return {
          status: "manual", confidence: "high",
          detail: "No 'line vty' block(s) found to evaluate for session-limit / transport input restrictions." + httpNote,
          evidence: []
        };
      }

      const req = REQUIREMENTS["CISC-ND-000010"] || {};
      const evidence = [];
      let allRestricted = true;
      let sawUnboundedValue = false;

      vtyBlocks.forEach(b => {
        const body = b.lines.join("\n");
        const sessLimitMatch = body.match(/^\s*session-limit\s+(\d+)/im);
        const noTransport = /^\s*transport input\s+none/im.test(body);
        if (noTransport) {
          evidence.push(`${b.header}: transport input none`);
          return;
        }
        if (sessLimitMatch) {
          const val = parseInt(sessLimitMatch[1], 10);
          if (req.maxSessionLimit != null && val > req.maxSessionLimit) {
            allRestricted = false;
            evidence.push(`${b.header}: session-limit ${val} (exceeds required ${req.maxSessionLimit})`);
          } else if (req.maxSessionLimit == null) {
            sawUnboundedValue = true;
            evidence.push(`${b.header}: session-limit ${val} (no fixed ceiling stated in this rule's check text - verify against your org's approved limit)`);
          } else {
            evidence.push(`${b.header}: session-limit ${val} (<= required ${req.maxSessionLimit})`);
          }
        } else {
          allRestricted = false;
          evidence.push(`${b.header}: no session-limit set and transport input is not 'none'`);
        }
      });

      if (!allRestricted) {
        return { match: false, confidence: "high", detail: "One or more 'line vty' block(s) are not restricted:" + httpNote, evidence };
      }
      if (sawUnboundedValue) {
        return {
          status: "manual", confidence: "medium",
          detail: "Every 'line vty' block has an explicit restriction, but this rule's check text doesn't mandate a specific session-limit ceiling - verify the configured value(s) against your organization's approved limit." + httpNote,
          evidence
        };
      }
      return { match: true, confidence: "high", detail: "All 'line vty' block(s) are restricted (session-limit within requirement or transport input none)." + httpNote, evidence };
    },

    "CISC-ND-000160": (cfg) => {
      // Asymmetric confidence: a COMPLETELY missing banner is an unambiguous
      // finding - no login banner is definitely wrong. But the actual DISA-
      // mandated banner text is long, specific, and legally significant, so
      // presence of "banner login" alone doesn't prove the TEXT is correct -
      // that needs a human to actually read it. Auto-fail the clear case,
      // defer the ambiguous case to manual review with the banner text
      // extracted for easy comparison.
      //
      // Cisco's "banner login <delimiter>" syntax uses a delimiter CHARACTER
      // (or short token - commonly "^", sometimes "^C", "%", "#", etc.) that
      // appears both right after "banner login" and again alone on its own
      // line to close the banner. The body text in between is normally NOT
      // indented - unlike line/interface sub-blocks elsewhere in an IOS
      // config. An earlier version of this check assumed indentation and
      // stopped at the very first (unindented) body line, so real banners
      // extracted as empty text. Find the actual delimiter token and use it
      // to locate the true end of the banner instead of guessing from
      // indentation.
      const open = cfg.match(/^banner login\s+(\S+)\r?\n/im);
      if (!open) {
        return { match: false, confidence: "high", detail: "No 'banner login' statement found in configuration." };
      }
      const delim = open[1];
      const afterOpen = cfg.slice(open.index + open[0].length);
      const bodyLines = afterOpen.split(/\r?\n/);
      const closeIdx = bodyLines.findIndex(line => line.trim() === delim);
      const bannerLines = closeIdx === -1 ? bodyLines.slice(0, 5) : bodyLines.slice(0, closeIdx);
      let bannerText = bannerLines.map(l => l.trim()).filter(Boolean).join(" / ");
      if (bannerText.length > 200) bannerText = bannerText.slice(0, 200) + "...";
      const closeNote = closeIdx === -1 ? " (closing delimiter not found - showing the first few lines only)" : "";
      return {
        status: "manual", confidence: "medium",
        detail: "'banner login' is configured - verify the exact text matches the DoD-mandated Standard Mandatory Notice and Consent wording (this cannot be verified by pattern matching alone)." + closeNote,
        evidence: [`banner login text: "${bannerText}"`]
      };
    },

    "CISC-ND-000470": (cfg, cc, rule) => {
      const bad = PROHIBITED_SERVICES.services;
      // Best-effort cross-check against the actual loaded STIG's check text
      // for this rule: if a service in our table doesn't even appear in
      // check_content, flag it so a stale hardcoded list doesn't silently
      // diverge from a revised STIG without anyone noticing.
      const checkText = (rule && rule.check_content) ? rule.check_content.toLowerCase() : null;
      const untethered = checkText ? bad.filter(svc => !checkText.includes(svc.toLowerCase())) : [];
      const staleNote = untethered.length
        ? ` Note: ${untethered.length} of the services this checker looks for (${untethered.join(", ")}) don't appear in this rule's own check text - verify this list is still current for the loaded STIG revision.`
        : "";
      const found = bad.filter(svc => new RegExp("^\\s*" + escapeRegex(svc) + "\\b", "im").test(cfg));
      if (found.length === 0) {
        return { match: true, confidence: "high", detail: "None of the unnecessary/non-secure services checked were found enabled." + staleNote };
      }
      return { match: false, confidence: "high", detail: "Unnecessary service(s) still enabled: " + found.join(", ") + staleNote };
    },

    "CISC-ND-000490": (cfg) => {
      // Zero local accounts is an unambiguous finding - there's no
      // account-of-last-resort at all. But MORE than one is not
      // automatically a finding: dedicated service/break-glass accounts
      // are common and can be authorized exceptions. Rather than guessing,
      // surface exactly what was found and let a human confirm which
      // account is the designated one and whether the rest are documented.
      const names = [...new Set(allMatches(cfg, /^username\s+(\S+)/im).map(m => m[1]))];
      if (names.length === 0) {
        return { match: false, confidence: "high", detail: "No local user accounts found in configuration; an account-of-last-resort is required." };
      }
      if (names.length === 1) {
        return {
          status: "manual", confidence: "medium",
          detail: `Exactly one local account configured (${names[0]}) - matches the minimal expected case, but confirming it's documented as the account-of-last-resort (and correctly placed in the authentication order) requires manual review.`,
          evidence: [`username ${names[0]}`]
        };
      }
      return {
        status: "manual", confidence: "medium",
        detail: `Found ${names.length} local account(s): ${names.join(", ")}. More than one account isn't automatically a finding - service/break-glass accounts can be authorized exceptions - but a human needs to verify which account is the designated account-of-last-resort and whether the additional accounts are documented/authorized.`,
        evidence: names.map(n => `username ${n}`)
      };
    },

    "CISC-ND-000550": (cfg, cc) => ccCheckByRule(cc, "CISC-ND-000550"),
    "CISC-ND-000570": (cfg, cc) => ccCheckByRule(cc, "CISC-ND-000570"),
    "CISC-ND-000580": (cfg, cc) => ccCheckByRule(cc, "CISC-ND-000580"),
    "CISC-ND-000590": (cfg, cc) => ccCheckByRule(cc, "CISC-ND-000590"),
    "CISC-ND-000600": (cfg, cc) => ccCheckByRule(cc, "CISC-ND-000600"),
    "CISC-ND-000610": (cfg, cc) => ccCheckByRule(cc, "CISC-ND-000610"),

    "CISC-ND-000620": (cfg) => {
      // See RULE_METADATA["CISC-ND-000620"] for why Type 5 doesn't fail here.
      const rationale = RULE_METADATA["CISC-ND-000620"].rationale;
      const encSvc = /^service password-encryption/im.test(cfg);
      const secretMatch = cfg.match(/^enable secret\s+(\d+)\s/im);
      const encSecret = !!secretMatch;
      const weakEnable = /^enable password/im.test(cfg) && !/^enable password\s+secret/im.test(cfg);
      if (encSvc && encSecret && !weakEnable) {
        const hashType = secretMatch[1];
        const note = hashType === "5" ? ` (Type 5/MD5 - ${rationale})` : ` (Type ${hashType})`;
        return { match: true, confidence: "high", detail: `'service password-encryption' and 'enable secret' are configured; no weak 'enable password' found${note}.`, evidence: [`enable secret ${hashType} ...`] };
      }
      const missing = [];
      if (!encSvc) missing.push("service password-encryption");
      if (!encSecret) missing.push("enable secret");
      if (weakEnable) missing.push("weak 'enable password' is present");
      return { match: false, confidence: "high", detail: "Password encryption issue(s): " + missing.join("; ") };
    },

    "CISC-ND-000720": (cfg) => {
      // This rule's own check text (V-220544) requires BOTH pieces to
      // terminate idle management connections after 5 minutes:
      //   1. exec-timeout <= 5 min on every "line con"/"line vty" block
      //   2. "ip http timeout-policy idle <=300 ..." whenever the HTTP or
      //      HTTPS management server is actually enabled.
      // An earlier version of this check only verified piece 1 - a config
      // with a perfectly fine exec-timeout but no http timeout-policy (or
      // one exceeding 300 seconds) while HTTP/HTTPS management was active
      // would have incorrectly passed.
      //
      // Evaluate exec-timeout per line con/vty BLOCK using the shared IOS
      // hierarchy parser, not a single regex's lookahead guessing where a
      // block ends - handles split vty ranges (0 4 / 5 15) and other
      // layouts uniformly. A block with no exec-timeout at all defaults to
      // a longer Cisco default and is just as much a finding as one
      // explicitly set too high.
      const blocks = parseLineBlocks(cfg).filter(b => /^line\s+(con|vty)\b/i.test(b.header));
      if (blocks.length === 0) {
        return { match: false, confidence: "high", detail: "No 'line con' or 'line vty' blocks found to evaluate." };
      }
      const tooLong = [];
      const evidence = [];
      let missing = 0;
      blocks.forEach(b => {
        const body = b.lines.join("\n");
        const m = body.match(/^\s*exec-timeout\s+(\d+)\s+(\d+)/im);
        if (m) {
          const min = parseInt(m[1], 10), sec = parseInt(m[2], 10);
          evidence.push(`${b.header}: exec-timeout ${min} ${sec}`);
          if (min > 5 || (min === 0 && sec === 0)) tooLong.push(`${b.header} (${min}:${sec})`);
        } else {
          missing++;
          evidence.push(`${b.header}: no exec-timeout set`);
        }
      });
      const lineOk = tooLong.length === 0 && missing === 0;

      // HTTP/HTTPS timeout-policy piece. If the management server is
      // explicitly disabled ("no ip http server" AND "no ip http
      // secure-server"), the requirement doesn't apply at all. If it's
      // explicitly enabled, "ip http timeout-policy idle <=300 ..." is
      // required. If neither an explicit enable NOR a full explicit
      // disable is present, the platform's default state can't be proven
      // from a static config file (this varies by platform/release), so
      // that piece is deferred to manual review instead of assumed either
      // way - hence this check is opt-in via the "Uncertain checks" panel.
      const httpEnabled = /^ip http server\b/im.test(cfg) || /^ip http secure-server\b/im.test(cfg);
      const httpExplicitlyDisabled = /^no ip http server\b/im.test(cfg) && /^no ip http secure-server\b/im.test(cfg);
      const httpTimeoutMatch = cfg.match(/^ip http timeout-policy\s+idle\s+(\d+)/im);

      let httpState, httpDetail;
      if (httpExplicitlyDisabled) {
        httpState = "na";
        httpDetail = "HTTP/HTTPS management is explicitly disabled ('no ip http server' and 'no ip http secure-server') - the timeout-policy requirement doesn't apply.";
        evidence.push("no ip http server", "no ip http secure-server");
      } else if (httpEnabled) {
        if (httpTimeoutMatch) {
          const idleSec = parseInt(httpTimeoutMatch[1], 10);
          evidence.push(`ip http timeout-policy idle ${idleSec} ...`);
          if (idleSec <= 300) {
            httpState = "ok";
            httpDetail = `HTTP/HTTPS management is enabled with 'ip http timeout-policy idle ${idleSec}' (<= 300 seconds / 5 minutes).`;
          } else {
            httpState = "bad";
            httpDetail = `HTTP/HTTPS management is enabled, but 'ip http timeout-policy idle ${idleSec}' exceeds the 300-second (5-minute) limit.`;
          }
        } else {
          httpState = "bad";
          httpDetail = "HTTP/HTTPS management is enabled, but no 'ip http timeout-policy idle ...' was found.";
        }
      } else {
        httpState = "ambiguous";
        httpDetail = "Couldn't confirm whether HTTP/HTTPS management is enabled or disabled from this config alone (no explicit 'ip http server'/'ip http secure-server', and no explicit 'no ip http server'/'no ip http secure-server' for both) - the platform's default state can't be proven from a static file. If HTTP/HTTPS management IS enabled on the live device, 'ip http timeout-policy idle <= 300 ...' would also be required.";
      }

      if (!lineOk) {
        const parts = [];
        if (missing > 0) parts.push(`${missing} block(s) with no exec-timeout at all`);
        if (tooLong.length > 0) parts.push(`exceeding 5 min or disabled: ${tooLong.join(", ")}`);
        if (httpState === "bad") parts.push(httpDetail);
        return { match: false, confidence: "high", detail: "Issue(s): " + parts.join("; ") + ".", evidence };
      }
      if (httpState === "bad") {
        return { match: false, confidence: "high", detail: `All ${blocks.length} line con/vty block(s) have exec-timeout configured <= 5 minutes, but ${httpDetail}`, evidence };
      }
      if (httpState === "ambiguous") {
        return { status: "manual", confidence: "medium", detail: `All ${blocks.length} line con/vty block(s) have exec-timeout configured <= 5 minutes. ${httpDetail}`, evidence };
      }
      return { match: true, confidence: "high", detail: `All ${blocks.length} line con/vty block(s) have exec-timeout configured <= 5 minutes. ${httpDetail}`, evidence };
    },

    "CISC-ND-001030": (cfg) => {
      // Dedupe - two lines pointing at the same server IP isn't redundancy.
      const servers = parseNtpServers(cfg);
      const uniqueAddrs = [...new Set(servers.map(s => s.address))];
      const evidence = servers.map(s => s.raw);
      if (uniqueAddrs.length >= 2) {
        return { match: true, confidence: "high", detail: `${uniqueAddrs.length} unique NTP server(s) configured: ${uniqueAddrs.join(", ")} (at least two unique sources present).`, evidence };
      } else if (uniqueAddrs.length === 1) {
        return { match: false, confidence: "high", detail: `Only one unique NTP server configured (${uniqueAddrs[0]}); a redundant/secondary source is required.`, evidence };
      }
      return { match: false, confidence: "high", detail: "No 'ntp server' statement found in configuration." };
    },

    "CISC-ND-001150": (cfg) => {
      // It's not enough for "ntp authenticate", "ntp authentication-key",
      // "ntp trusted-key", and "ntp server ... key" to each exist somewhere -
      // they have to reference the SAME key ID to actually form a working
      // authentication chain. Three independently-present but mismatched
      // key IDs (e.g. key 1 configured, key 2 trusted, server uses key 3)
      // means NTP auth is effectively broken despite every line "existing."
      //
      // CRITICAL: this check's own text states "Cisco IOS is limited to MD5
      // for NTP authentication, and incurs a PERMANENT FINDING as it is not
      // FIPS compliant." A correctly-chained MD5 key is NOT compliant on
      // IOS - it's explicitly, permanently a finding per DISA's own words.
      // Only a SHA-based chain (where the platform supports it) can pass.
      //
      // Strengthened: this used to pass as soon as ONE server had a working
      // authenticated chain, even if OTHER configured NTP servers had no key
      // at all. Every configured server that's expected to participate in
      // synchronization must itself be authenticated - so now every server
      // from parseNtpServers() is checked individually.
      const authEnabled = /^ntp authenticate\s*$/im.test(cfg);
      const keyEntries = allMatches(cfg, /^ntp authentication-key\s+(\d+)\s+(md5|sha1|sha2)\s+/im).map(m => ({ id: m[1], algo: m[2].toLowerCase() }));
      const trustedIds = new Set(allMatches(cfg, /^ntp trusted-key\s+(\d+)\s*$/im).map(m => m[1]));
      const keyById = new Map(keyEntries.map(k => [k.id, k.algo]));
      const servers = parseNtpServers(cfg);

      if (servers.length === 0) {
        return { match: false, confidence: "high", detail: "No 'ntp server' statement found in configuration." };
      }
      if (!authEnabled) {
        return { match: false, confidence: "high", detail: "'ntp authenticate' is not enabled globally.", evidence: servers.map(s => s.raw) };
      }

      const unauthenticated = [];
      const weakMd5 = [];
      const compliant = [];
      servers.forEach(s => {
        if (!s.key) {
          unauthenticated.push(`${s.raw} (no key clause)`);
          return;
        }
        if (!trustedIds.has(s.key) || !keyById.has(s.key)) {
          unauthenticated.push(`${s.raw} (key ${s.key} is not both defined via 'ntp authentication-key' and trusted via 'ntp trusted-key')`);
          return;
        }
        const algo = keyById.get(s.key);
        if (algo === "md5") {
          weakMd5.push(`${s.raw} (key ${s.key}, MD5)`);
        } else {
          compliant.push(`${s.raw} (key ${s.key}, ${algo})`);
        }
      });

      if (unauthenticated.length > 0) {
        return {
          match: false, confidence: "high",
          detail: `Every configured NTP server must use a valid, trusted authentication key. Server(s) that don't: ${unauthenticated.join("; ")}.`,
          evidence: [...unauthenticated, ...weakMd5, ...compliant]
        };
      }
      if (weakMd5.length > 0) {
        return {
          match: false, confidence: "high",
          detail: `Every configured server references a defined and trusted key, but ${weakMd5.length} of them use MD5 - per this rule's own check text, Cisco IOS is limited to MD5 for NTP auth and that is explicitly a PERMANENT FINDING (not FIPS-compliant), regardless of correct configuration: ${weakMd5.join("; ")}.`,
          evidence: [...weakMd5, ...compliant]
        };
      }
      return {
        match: true, confidence: "high",
        detail: `NTP authentication is fully configured with a FIPS-compliant algorithm for every configured server: ${compliant.join("; ")}.`,
        evidence: compliant
      };
    },

    // ---- Newly automated rules (added after the manual-review evidence
    // feature made it easy to see which of the remaining rules are simple
    // deterministic presence/threshold checks vs. ones that genuinely need
    // a human, live device output, or external data) ----

    "CISC-ND-000150": (cfg) => {
      // check_content's actual finding criterion is only "enforces the limit
      // of three consecutive invalid logon attempts" - the block-for/within
      // durations in DISA's example are illustrative, not independently
      // mandated minimums. Validating only "attempts" (not inventing a
      // required 900/120) is deliberate, not an oversight - but the other
      // two values are surfaced as evidence so a reviewer can sanity-check
      // them against their own org's policy.
      const req = REQUIREMENTS["CISC-ND-000150"];
      const m = cfg.match(/^login block-for\s+(\d+)\s+attempts\s+(\d+)\s+within\s+(\d+)/im);
      if (!m) return { match: false, confidence: "high", detail: "No 'login block-for ... attempts N within M' statement found." };
      const [, blockFor, attemptsStr, within] = m;
      const attempts = parseInt(attemptsStr, 10);
      const evidence = [`login block-for ${blockFor} attempts ${attempts} within ${within}`];
      return attempts <= req.maxAttempts
        ? { match: true, confidence: "high", detail: `login block-for configured with attempts=${attempts} (<= ${req.maxAttempts}, the only value this rule's check text explicitly mandates). Block duration (${blockFor}s) and window (${within}s) are shown for reference - verify they're reasonable for your environment.`, evidence }
        : { match: false, confidence: "high", detail: `login block-for configured with attempts=${attempts} (> ${req.maxAttempts} allowed consecutive failures).`, evidence };
    },

    "CISC-ND-000090": (cfg) => auditArchiveLogConfigEnabled(cfg, "account creation"),
    "CISC-ND-000100": (cfg) => auditArchiveLogConfigEnabled(cfg, "account modification"),
    "CISC-ND-000110": (cfg) => auditArchiveLogConfigEnabled(cfg, "account disabling"),
    "CISC-ND-000120": (cfg) => auditArchiveLogConfigEnabled(cfg, "account removal"),

    "CISC-ND-000210": (cfg) => {
      // This rule's own check text example shows BOTH pieces together
      // ("logging userinfo" AND an archive/log config/logging enable
      // block) - logging userinfo alone only catches privilege-escalation
      // events, not the broader configuration-change audit trail the rule
      // is actually asking for. An earlier version of this check only
      // verified the first half.
      const userinfoOk = /^logging userinfo/im.test(cfg);
      const archiveResult = auditArchiveLogConfigEnabled(cfg, "administrator activity");
      if (userinfoOk && archiveResult.match) {
        return {
          match: true, confidence: "high",
          detail: "'logging userinfo' is configured (logs privilege escalation) AND the 'archive log config logging enable' block is present (logs configuration changes) - together these audit administrator activity as this rule's check text requires.",
          evidence: ["logging userinfo", "archive", " log config", "  logging enable"]
        };
      }
      const missing = [];
      if (!userinfoOk) missing.push("'logging userinfo' (logs privilege escalation)");
      if (!archiveResult.match) missing.push("'archive / log config / logging enable' (logs configuration changes)");
      return { match: false, confidence: "high", detail: "Missing: " + missing.join(" and ") + "." };
    },

    "CISC-ND-000280": (cfg) => {
      return /^service timestamps log datetime/im.test(cfg)
        ? { match: true, confidence: "high", detail: "'service timestamps log datetime' is configured." }
        : { match: false, confidence: "high", detail: "No 'service timestamps log datetime' statement found." };
    },

    "CISC-ND-000330": (cfg) => auditArchiveLogConfigEnabled(cfg, "full-text recording of privileged commands"),

    "CISC-ND-000880": (cfg) => auditArchiveLogConfigEnabled(cfg, "account enabling"),

    "CISC-ND-000980": (cfg) => {
      // No minimum buffer size is specified anywhere in check_content
      // ("xxxxxxxx" in DISA's example is a placeholder, not a number) -
      // presence-only is correct here, not a shortcut. Size is still
      // surfaced as evidence for the reviewer's own sanity check.
      const m = cfg.match(/^logging buffered\s+(\d+)/im);
      return m
        ? { match: true, confidence: "high", detail: `Logging buffer size configured: ${m[1]} bytes. (This rule's check text specifies no minimum size - presence is the only stated requirement.)`, evidence: [`logging buffered ${m[1]}`] }
        : { match: false, confidence: "high", detail: "No 'logging buffered <size>' statement found." };
    },

    "CISC-ND-001250": (cfg) => auditArchiveLogConfigEnabled(cfg, "log records when administrator privileges are deleted"),

    "CISC-ND-001260": (cfg) => {
      const fail = /^login on-failure log/im.test(cfg);
      const success = /^login on-success log/im.test(cfg);
      if (fail && success) return { match: true, detail: "Both 'login on-failure log' and 'login on-success log' are configured." };
      const missing = [];
      if (!fail) missing.push("login on-failure log");
      if (!success) missing.push("login on-success log");
      return { match: false, detail: "Missing: " + missing.join(", ") };
    },

    "CISC-ND-001270": (cfg) => auditArchiveLogConfigEnabled(cfg, "log records for privileged activities"),

    "CISC-ND-001370": (cfg) => {
      // "aaa authentication login default local" plus two radius/tacacs-
      // server lines would previously pass, even though "local" alone means
      // the servers aren't actually being used as the auth method. Require
      // at least one aaa authentication login line to actually invoke a
      // server group, not just exist in any form.
      //
      // Strengthened further: 1 TACACS+ server + 1 RADIUS server used to
      // satisfy a ">= 2 servers" threshold even though that isn't redundant
      // for EITHER method individually. Every "group <token>" referenced in
      // the method list is resolved to an actual server pool and requires
      // >= 2 servers of THAT pool specifically:
      //   - "group tacacs+"/"group radius" (the built-in keyword) resolves
      //     to the GLOBAL pool for that type - every "tacacs-server host",
      //     "tacacs server NAME"/address, and "aaa group server tacacs+
      //     NAME"/server-private entry in the config (same for radius).
      //   - "group <custom-name>" (e.g. "group CorpAAA") resolves to
      //     exactly the servers declared inside that group's OWN
      //     "aaa group server tacacs+|radius <custom-name>" block - a
      //     custom group name has nothing to do with "tacacs"/"radius" as
      //     text, so it can't be recognized by string-matching the token;
      //     it has to be looked up against groups actually defined in the
      //     config (parseAaaGroups).
      //   - a token that resolves to neither is left for manual review
      //     rather than assumed to be Open or Pass.
      // The full method-list line is preserved verbatim as evidence so the
      // configured authentication ORDER (e.g. "group tacacs+ local" vs
      // "local group tacacs+") is visible to a reviewer, not just presence.
      const aaaModel = /^aaa new-model/im.test(cfg);
      const aaaLoginLines = allMatches(cfg, /^aaa authentication login\s+.*$/im).map(m => m[0].trim());
      const groupLines = aaaLoginLines.filter(l => /\bgroup\s+\S+/i.test(l));

      if (!aaaModel) {
        return { match: false, confidence: "high", detail: "'aaa new-model' is not configured.", evidence: aaaLoginLines };
      }
      if (groupLines.length === 0) {
        return {
          match: false, confidence: "high",
          detail: "No 'aaa authentication login' line references any server group - servers may be configured but unused (e.g. login method is 'local' only).",
          evidence: aaaLoginLines
        };
      }

      const aaaGroups = parseAaaGroups(cfg);
      const globalTacacs = parseAaaServers(cfg, "tacacs");
      const globalRadius = parseAaaServers(cfg, "radius");

      // De-dupe by address when one is known; entries with no discoverable
      // address each still count individually, since they can't be proven
      // to be duplicates of anything.
      function uniqueCount(servers) {
        const seenAddrs = new Set();
        let count = 0;
        servers.forEach(s => {
          if (s.address) {
            if (seenAddrs.has(s.address)) return;
            seenAddrs.add(s.address);
          }
          count++;
        });
        return count;
      }

      const evidence = [...groupLines];
      const problems = [];
      const unresolvedTokens = new Set();
      let anyTypeSatisfied = false;

      groupLines.forEach(l => {
        allMatches(l, /\bgroup\s+(\S+)/gi).forEach(gm => {
          const token = gm[1].replace(/[,;]+$/, "");
          const lower = token.toLowerCase();
          let type = null, pool = null;
          if (lower === "tacacs+" || lower === "tacacs") { type = "TACACS+"; pool = globalTacacs; }
          else if (lower === "radius") { type = "RADIUS"; pool = globalRadius; }
          else if (aaaGroups.has(lower)) {
            const g = aaaGroups.get(lower);
            type = `${g.type === "tacacs" ? "TACACS+" : "RADIUS"} group "${token}"`;
            pool = g.servers;
          } else {
            unresolvedTokens.add(token);
            return;
          }
          const count = uniqueCount(pool);
          evidence.push(...pool.map(s => s.raw));
          if (count >= 2) anyTypeSatisfied = true;
          else problems.push(`${type} is used for login but only ${count} unique server(s) were found for it (need >= 2 of the SAME group for redundancy)`);
        });
      });

      if (unresolvedTokens.size > 0) {
        return {
          status: "manual", confidence: "medium",
          detail: `The login method list references group(s) that don't match "tacacs+"/"radius" and don't match any "aaa group server ..." block found in this config: ${[...unresolvedTokens].join(", ")}. Verify manually whether that group has >= 2 redundant servers (it may be defined in a separate config fragment not included here).`,
          evidence
        };
      }
      if (anyTypeSatisfied && problems.length === 0) {
        return {
          match: true, confidence: "high",
          detail: `aaa new-model is present and the login method list resolves to at least one server group backed by >= 2 servers. Configured authentication order: ${groupLines.join(" | ")}.`,
          evidence
        };
      }
      return { match: false, confidence: "high", detail: "Issue(s): " + problems.join("; "), evidence };
    },

    "CISC-ND-001450": (cfg) => {
      // Positive pattern instead of a growing negative-lookahead exclusion
      // list, and now handles the optional "vrf <name>" clause Cisco allows
      // between "logging host" and the target. IPv6 addresses and FQDNs
      // already match \S+ without any extra handling needed.
      const hostForm = allMatches(cfg, /^logging host\s+(?:vrf\s+\S+\s+)?(\S+)/im).map(m => m[1]);
      const bareForm = allMatches(cfg, /^logging\s+(?:vrf\s+\S+\s+)?((?!buffered|trap|userinfo|persistent|enable|source-interface|facility|synchronous|monitor|console|history|rate-limit|on|off)\S+)$/im).map(m => m[1]);
      const servers = [...new Set([...hostForm, ...bareForm])];
      return servers.length >= 2
        ? { match: true, confidence: "medium", detail: `${servers.length} syslog server(s) configured: ${servers.join(", ")}.`, evidence: servers.map(s => `logging ${s}`) }
        : { match: false, confidence: "medium", detail: `Only ${servers.length} syslog server(s) found (${servers.join(", ") || "none"}); at least 2 required for redundancy. Note: this regex may not catch every valid Cisco logging syntax variant.` };
    },

    "CISC-ND-001200": (cfg) => {
      // Three states instead of two: an explicit secure restriction passes,
      // an explicit weak algorithm fails, but the ABSENCE of any explicit
      // restriction is neither.
      //
      // Same reasoning now applies to "ip ssh version 2" itself: modern
      // IOS-XE ships with SSHv1 unsupported and defaults to v2, so a
      // config file that never explicitly sets "ip ssh version 2" is NOT
      // proof the device is running v1 or something non-compliant - it's
      // just unconfirmable from static text. Confirming the live version
      // actually requires running "show ip ssh" on the device, which is
      // outside what this tool can see. So: explicit "ip ssh version 2"
      // present is confidently Not a Finding for this piece; absent goes
      // to Manual Review rather than an automatic Open. This check is
      // opt-in via the "Uncertain checks" panel because of that residual
      // ambiguity.
      const verOk = /^ip ssh version 2/im.test(cfg);
      if (!verOk) {
        return {
          status: "manual", confidence: "low",
          detail: "No explicit 'ip ssh version 2' line found. Modern IOS-XE defaults to SSHv2 (v1 isn't even supported), so this alone doesn't mean the device is noncompliant - but confirming the live version requires running 'show ip ssh' on the device, which a static config file can't prove either way.",
          evidence: []
        };
      }
      const m = cfg.match(/^ip ssh server algorithm mac\s+(.+)$/im);
      if (!m) {
        return {
          status: "manual", confidence: "medium",
          detail: "SSH version 2 is explicitly set, but no explicit 'ip ssh server algorithm mac' restriction was found. Modern IOS-XE secure defaults may already exclude weak MACs, but that can't be confirmed from the running-config alone - verify the platform's default MAC set or an active session's negotiated algorithm.",
          evidence: [`ip ssh version 2`]
        };
      }
      const algos = m[1].trim().split(/\s+/);
      const weak = algos.filter(a => /md5|hmac-sha1(?!-2)|^sha1$/i.test(a));
      if (weak.length > 0) return { match: false, confidence: "high", detail: `Weak MAC algorithm(s) allowed: ${weak.join(", ")}.`, evidence: [`ip ssh server algorithm mac ${algos.join(" ")}`] };
      return { match: true, confidence: "high", detail: `SSH version 2 is explicit and MAC is restricted to: ${algos.join(", ")}.`, evidence: [`ip ssh version 2`, `ip ssh server algorithm mac ${algos.join(" ")}`] };
    },

    "CISC-ND-001210": (cfg) => {
      // Same three-state logic (including the SSH-version precondition) as
      // the MAC check above - see CISC-ND-001200 for the full rationale.
      // Also opt-in via the "Uncertain checks" panel for the same reason.
      const verOk = /^ip ssh version 2/im.test(cfg);
      if (!verOk) {
        return {
          status: "manual", confidence: "low",
          detail: "No explicit 'ip ssh version 2' line found. Modern IOS-XE defaults to SSHv2 (v1 isn't even supported), so this alone doesn't mean the device is noncompliant - but confirming the live version requires running 'show ip ssh' on the device, which a static config file can't prove either way.",
          evidence: []
        };
      }
      const m = cfg.match(/^ip ssh server algorithm encryption\s+(.+)$/im);
      if (!m) {
        return {
          status: "manual", confidence: "medium",
          detail: "SSH version 2 is explicitly set, but no explicit 'ip ssh server algorithm encryption' restriction was found. Modern IOS-XE secure defaults may already exclude weak ciphers, but that can't be confirmed from the running-config alone - verify the platform's default cipher set or an active session's negotiated algorithm.",
          evidence: [`ip ssh version 2`]
        };
      }
      const algos = m[1].trim().split(/\s+/);
      const weak = algos.filter(a => /(^|-)(3des|des)(-|$)|cbc/i.test(a));
      if (weak.length > 0) return { match: false, confidence: "high", detail: `Weak/disallowed cipher(s) allowed: ${weak.join(", ")}.`, evidence: [`ip ssh server algorithm encryption ${algos.join(" ")}`] };
      return { match: true, confidence: "high", detail: `SSH version 2 is explicit and encryption is restricted to: ${algos.join(", ")}.`, evidence: [`ip ssh version 2`, `ip ssh server algorithm encryption ${algos.join(" ")}`] };
    },

    // CISC-ND-000380/000390/000460 all share the identical technical check
    // (file system privilege level, conditional on persistent logging being
    // enabled at all) - they cover different NIST control families but the
    // config-side verification is the same.
    "CISC-ND-000380": (cfg) => checkFilePrivilege(cfg),
    "CISC-ND-000390": (cfg) => checkFilePrivilege(cfg),
    "CISC-ND-000460": (cfg) => checkFilePrivilege(cfg)
  };

  // =====================================================================
  // ROUTER PLATFORM (Cisco IOS-XR Router NDM + RTR STIGs)
  // =====================================================================
  // CRITICAL: the Router NDM STIG reuses the EXACT SAME rule_version IDs
  // as the Switch NDM STIG above (e.g. "CISC-ND-000010", "CISC-ND-000160"),
  // for a completely different command syntax (IOS-XR vs IOS-XE). A single
  // shared RULE_CHECKS table would silently run switch-syntax regexes
  // against router configs (or vice versa) whenever the two happen to
  // share a rule ID - so router gets its OWN, separate table, selected at
  // runtime by inspecting which STIG each rule actually came from (see
  // detectPlatformForStig below). CISC-RT-* (the RTR STIG) rule IDs don't
  // collide with anything and live in this same table for convenience.
  //
  // Every check below is grounded in the actual check_content of the
  // Cisco IOS-XR Router NDM/RTR STIG (verified against a real .cklb, not
  // guessed from rule titles) - several are DELIBERATELY NOT the same
  // logic as their switch counterparts because the platform facts differ:
  //   - Router's SSH-version rule has no "modern default" leniency the
  //     way switch's does - IOS-XR still actively supports SSHv1, so
  //     absence of 'ssh server v2' is a real finding here, not a manual
  //     deferral.
  //   - Router's NTP-authentication rule's own check text only shows
  //     hmac-sha2 as compliant (no MD5 example the way switch's does), so
  //     MD5 is treated as a real finding here, not tolerated.
  // =====================================================================

  function parseXRInterfaceBlocks(cfg) {
    return parseConfigBlocks(cfg, /^interface\s+\S+/i);
  }

  function parseXRLineBlocks(cfg) {
    return parseConfigBlocks(cfg, /^line\s+(console|default|aux)\b/i);
  }

  // IOS-XR nests NTP config under a bare "ntp" mode line, with
  // "server"/"authenticate"/"authentication-key"/"trusted-key" as indented
  // sub-lines with NO "ntp " prefix - a fundamentally different structure
  // from IOS-XE's flat top-level "ntp server ..." commands.
  function parseXRNtpBlock(cfg) {
    const blocks = parseConfigBlocks(cfg, /^ntp\s*$/i);
    return blocks.length ? blocks[0].lines.join("\n") : "";
  }

  function parseXRNtpServers(ntpBody) {
    return allMatches(ntpBody, /^\s*server\s+(\S+)(.*)$/im).map(m => {
      const rest = m[2] || "";
      const keyMatch = rest.match(/\bkey\s+(\d+)/i);
      return { raw: m[0].trim(), address: m[1], key: keyMatch ? keyMatch[1] : null };
    });
  }

  // Only the legacy "tacacs-server host"/"radius-server host" syntax is
  // covered here - that's the only form evidenced in this STIG's own
  // check_content examples. If IOS-XR also supports a modern block syntax
  // analogous to IOS-XE's (unverified), a device using ONLY that form
  // would be under-counted here - each check below notes this explicitly
  // wherever server count matters for the verdict.
  function parseXRAaaServers(cfg, kind) {
    const re = kind === "tacacs" ? /^tacacs-server host\s+(\S+)/im : /^radius-server host\s+(\S+)/im;
    return allMatches(cfg, re).map(m => ({ address: m[1], raw: m[0].trim() }));
  }

  // "logging <token> ..." is heavily overloaded in IOS-XR - most of its
  // sub-features (buffered size, console severity, archive, trap level,
  // source-interface, etc.) share the same "logging <keyword> ..." shape
  // as an actual syslog HOST destination ("logging <ip-or-hostname> vrf
  // ... severity ..."). Distinguish by excluding the known non-host
  // keywords rather than trying to positively identify an IP/hostname
  // (which would also have to handle bare hostnames, not just IPs).
  const XR_LOGGING_NON_HOST_KEYWORDS = new Set([
    "buffered", "console", "trap", "source-interface", "archive", "monitor",
    "facility", "hostnameprefix", "suppress", "history", "format",
    "tls-server", "events", "correlator", "esm", "on-failure", "on-success",
    "userinfo", "explicit-priority"
  ]);
  function parseXRSyslogHosts(cfg) {
    return allMatches(cfg, /^logging\s+(\S+)(.*)$/im)
      .filter(m => !XR_LOGGING_NON_HOST_KEYWORDS.has(m[1].toLowerCase()))
      .map(m => {
        const rest = m[2] || "";
        const sevMatch = rest.match(/\bseverity\s+(\S+)/i);
        return { address: m[1], raw: m[0].trim(), severity: sevMatch ? sevMatch[1].toLowerCase() : null };
      });
  }

  function parseXRAclBlocks(cfg) {
    return parseConfigBlocks(cfg, /^ipv4 access-list\s+\S+/i);
  }

  // IOS-XR username blocks declare "group X" (role) and "secret ..." as
  // indented sub-lines, rather than IOS-XE's single-line
  // "username X privilege N secret ...".
  function parseXRLocalUsers(cfg) {
    return parseConfigBlocks(cfg, /^username\s+\S+/i).map(b => {
      const name = b.header.replace(/^username\s+/i, "").trim();
      const body = b.lines.join("\n");
      const groups = allMatches(body, /^\s*group\s+(\S+)/im).map(m => m[1]);
      return { name, groups, raw: b.header };
    });
  }

  function parseXRSnmpV3Users(cfg) {
    return allMatches(cfg, /^snmp-server user\s+\S+\s+\S+\s+v3\s+(.*)$/im).map(m => ({ raw: m[0].trim(), rest: m[1] }));
  }

  function checkXRSshV2(cfg) {
    // Unlike the switch NDM STIG's SSH-version check, this rule's check
    // text gives no basis for treating an unconfigured SSH version as
    // ambiguous-but-probably-fine - IOS-XR actively supports SSHv1, so its
    // absence is a real finding, not a manual deferral.
    return /^ssh server v2\b/im.test(cfg)
      ? { match: true, confidence: "high", detail: "'ssh server v2' is configured." }
      : { match: false, confidence: "high", detail: "No 'ssh server v2' statement found - IOS XR still actively supports SSHv1, so this must be explicitly set." };
  }

  function checkXRTimestamps(cfg) {
    return /^service timestamps log datetime\b/im.test(cfg)
      ? { match: true, confidence: "high", detail: "'service timestamps log datetime' is configured." }
      : { match: false, confidence: "high", detail: "No 'service timestamps log datetime' statement found." };
  }

  // Shared by CISC-ND-000470 (with the extra "service call-home" check)
  // and CISC-RT-000070 (without it) - same underlying service list.
  function checkXRUnnecessaryServices(cfg, includeCallHome) {
    const checks = [
      { re: /^service ipv4 tcp-small-servers\b/im, label: "service ipv4 tcp-small-servers" },
      { re: /^service ipv4 udp-small-servers\b/im, label: "service ipv4 udp-small-servers" },
      { re: /^http client vrf\b/im, label: "http client vrf ..." },
      { re: /^telnet vrf\s+\S+\s+ipv4 server\b/im, label: "telnet vrf ... ipv4 server (Telnet server enabled)" }
    ];
    if (includeCallHome) {
      checks.push({ re: /^service call-home\b/im, label: "service call-home (this rule's own note exempts legacy devices that require it for Smart Licensing - verify if that applies here)" });
    }
    const found = checks.filter(c => c.re.test(cfg)).map(c => c.label);
    if (found.length === 0) {
      return { match: true, confidence: "high", detail: "None of the unnecessary/non-secure services checked were found enabled." };
    }
    return { match: false, confidence: "high", detail: "Unnecessary service(s) still enabled: " + found.join(", ") + "." };
  }

  // Shared by CISC-ND-000290 and CISC-RT-000210/000220 - all three require
  // 'log-input' specifically (not plain 'log') on ACL deny statements, so
  // the log record captures WHERE/from-what-source a dropped packet came.
  function checkXRAclLogInput(cfg) {
    const aclBlocks = parseXRAclBlocks(cfg);
    if (aclBlocks.length === 0) {
      return { status: "manual", confidence: "medium", detail: "No 'ipv4 access-list' blocks found to evaluate." };
    }
    const withLogInput = [], withPlainLogOnly = [], withNoLog = [];
    aclBlocks.forEach(b => {
      allMatches(b.lines.join("\n"), /^\s*\d+\s+deny\s+.*$/gim).forEach(m => {
        const line = m[0].trim();
        if (/\blog-input\b/i.test(line)) withLogInput.push(line);
        else if (/\blog\b/i.test(line)) withPlainLogOnly.push(line);
        else withNoLog.push(line);
      });
    });
    if (withLogInput.length === 0 && withPlainLogOnly.length === 0 && withNoLog.length === 0) {
      return { status: "manual", confidence: "medium", detail: "No 'deny' statements found in any 'ipv4 access-list' block to evaluate." };
    }
    if (withPlainLogOnly.length === 0 && withNoLog.length === 0) {
      return { match: true, confidence: "high", detail: `All ${withLogInput.length} deny statement(s) found across ACLs use 'log-input'.`, evidence: withLogInput };
    }
    const problems = [];
    if (withPlainLogOnly.length) problems.push(`${withPlainLogOnly.length} deny statement(s) use plain 'log' instead of 'log-input' (doesn't record the ingress interface/source): ${withPlainLogOnly.join("; ")}`);
    if (withNoLog.length) problems.push(`${withNoLog.length} deny statement(s) have no logging at all: ${withNoLog.join("; ")}`);
    return { match: false, confidence: "high", detail: "Issue(s): " + problems.join("; ") + ".", evidence: [...withLogInput, ...withPlainLogOnly, ...withNoLog] };
  }

  // CISC-RT-000200 is more lenient than the log-input rules above - ANY
  // logging (plain 'log' OR 'log-input') satisfies it.
  function checkXRAclAnyLog(cfg) {
    const aclBlocks = parseXRAclBlocks(cfg);
    if (aclBlocks.length === 0) return { status: "manual", confidence: "medium", detail: "No 'ipv4 access-list' blocks found to evaluate." };
    const denyLines = [];
    aclBlocks.forEach(b => denyLines.push(...allMatches(b.lines.join("\n"), /^\s*\d+\s+deny\s+.*$/gim).map(m => m[0].trim())));
    if (denyLines.length === 0) return { status: "manual", confidence: "medium", detail: "No 'deny' statements found in any ACL to evaluate." };
    const unlogged = denyLines.filter(l => !/\blog(-input)?\b/i.test(l));
    if (unlogged.length === 0) return { match: true, confidence: "high", detail: `All ${denyLines.length} deny statement(s) across ACLs include logging.`, evidence: denyLines };
    return { match: false, confidence: "high", detail: `${unlogged.length} of ${denyLines.length} deny statement(s) have no logging: ${unlogged.join("; ")}`, evidence: denyLines };
  }

  // Heuristic used by several RTR "disabled on all EXTERNAL interfaces"
  // rules - IOS-XR gives no config-level flag for "this interface faces
  // an untrusted network," so this looks for common description keywords
  // as a best-effort signal. This is inherently fragile (a real external
  // interface with no matching keyword in its description is invisible to
  // this heuristic and will read as "nothing to check" rather than a
  // finding) - every rule using it is opt-in via the "Uncertain checks"
  // panel, off by default, for exactly that reason.
  const XR_EXTERNAL_IFACE_KEYWORDS = /\b(wan|external|untrusted|outside|internet|edge|uplink|perimeter|dmz)\b/i;
  function findLikelyExternalInterfaces(cfg) {
    return parseXRInterfaceBlocks(cfg).filter(b => {
      const descMatch = b.lines.join("\n").match(/^\s*description\s+(.*)$/im);
      return descMatch && XR_EXTERNAL_IFACE_KEYWORDS.test(descMatch[1]);
    });
  }
  function checkXRExternalIfaceAbsence(cfg, badCommandRegex, commandLabel) {
    const candidates = findLikelyExternalInterfaces(cfg);
    if (candidates.length === 0) {
      return {
        status: "manual", confidence: "low",
        detail: `Couldn't identify any "likely external" interface from description text (looked for keywords like WAN/external/untrusted/outside/uplink/edge/perimeter/DMZ) - verify ${commandLabel} manually on whichever interfaces actually face an untrusted network.`
      };
    }
    const bad = candidates.filter(b => badCommandRegex.test(b.lines.join("\n")));
    if (bad.length === 0) {
      return { match: true, confidence: "medium", detail: `None of the ${candidates.length} likely-external interface(s) (identified by description keyword) have ${commandLabel} enabled.`, evidence: candidates.map(b => b.header) };
    }
    return { match: false, confidence: "medium", detail: `${commandLabel} is enabled on likely-external interface(s): ${bad.map(b => b.header).join(", ")}.`, evidence: bad.map(b => b.header) };
  }

  const ROUTER_RULE_CHECKS = {
    // --- NDM (device management) ---
    "CISC-ND-000010": (cfg) => {
      const m = cfg.match(/^ssh server session-limit\s+(\d+)/im);
      return m
        ? { match: true, confidence: "high", detail: `'ssh server session-limit ${m[1]}' is configured, limiting concurrent management sessions.`, evidence: [m[0].trim()] }
        : { match: false, confidence: "high", detail: "No 'ssh server session-limit <N>' statement found - concurrent management sessions are not limited." };
    },

    "CISC-ND-000140": (cfg) => {
      const lineBlocks = parseXRLineBlocks(cfg).filter(b => /^line\s+default\b/i.test(b.header));
      const hasAccessClass = lineBlocks.some(b => /^\s*access-class ingress\s+\S+/im.test(b.lines.join("\n")));
      if (hasAccessClass) {
        return { match: true, confidence: "high", detail: "'line default' has an ingress access-class applied, restricting management access by policy.", evidence: lineBlocks.map(b => b.header) };
      }
      // This rule's own example doesn't mention it, but Management Plane
      // Protection can achieve a similar restriction - surface it for
      // manual confirmation rather than silently failing a device that
      // uses this alternate (and arguably stronger) mechanism instead.
      const mppBlocks = parseConfigBlocks(cfg, /^control-plane\s*$/i);
      const hasMpp = mppBlocks.some(b => /^\s*management-plane\b/im.test(b.lines.join("\n")));
      if (hasMpp) {
        return {
          status: "manual", confidence: "medium",
          detail: "No 'access-class ingress' on 'line default' (this rule's own example mechanism), but Management Plane Protection ('control-plane / management-plane') is configured, which can achieve a similar restriction - verify it actually scopes management access to the intended source(s), since this rule's check text doesn't evaluate MPP as an alternative.",
          evidence: mppBlocks.map(b => b.header)
        };
      }
      return { match: false, confidence: "high", detail: "No 'access-class ingress' on 'line default' and no Management Plane Protection configured - management traffic isn't restricted by policy." };
    },

    "CISC-ND-000150": (cfg) => {
      const loginLines = allMatches(cfg, /^aaa authentication login\s+.*$/im).map(m => m[0].trim());
      const usesRemoteGroup = loginLines.some(l => /group\s+(radius|tacacs\+?)/i.test(l));
      return usesRemoteGroup
        ? { match: true, confidence: "high", detail: "An 'aaa authentication login' line references a radius/tacacs group as primary authentication - per this rule's own check text, this fully mitigates the lockout requirement (IOS-XR has no native consecutive-failed-attempt lockout).", evidence: loginLines }
        : { match: false, confidence: "high", detail: "No 'aaa authentication login' line references a radius/tacacs group - IOS-XR has no native lockout mechanism, so an authentication server is required to mitigate this risk.", evidence: loginLines };
    },

    // Same "banner login <delim> ... <delim>" syntax as the switch NDM
    // STIG's identical rule - reuse that function directly rather than
    // duplicating the delimiter-parsing logic.
    "CISC-ND-000160": RULE_CHECKS["CISC-ND-000160"],

    "CISC-ND-000250": (cfg) => {
      const hasBuffered = /^logging buffered\b/im.test(cfg);
      const hosts = parseXRSyslogHosts(cfg);
      if (hasBuffered && hosts.length > 0) {
        return { match: true, confidence: "high", detail: "Logging is buffered locally and sent to at least one syslog host - login attempts will be captured.", evidence: ["logging buffered ...", ...hosts.map(h => h.raw)] };
      }
      const missing = [];
      if (!hasBuffered) missing.push("'logging buffered ...'");
      if (hosts.length === 0) missing.push("a syslog host destination ('logging <host> ...')");
      return { match: false, confidence: "high", detail: "Missing: " + missing.join(" and ") + "." };
    },

    "CISC-ND-000280": (cfg) => checkXRTimestamps(cfg),
    "CISC-ND-001040": (cfg) => checkXRTimestamps(cfg),

    "CISC-ND-000290": (cfg) => checkXRAclLogInput(cfg),

    "CISC-ND-000470": (cfg) => checkXRUnnecessaryServices(cfg, true),

    "CISC-ND-000490": (cfg) => {
      const users = parseXRLocalUsers(cfg);
      if (users.length === 0) {
        return { match: false, confidence: "high", detail: "No local user accounts found; an account-of-last-resort is required." };
      }
      const disallowed = users.filter(u => u.groups.some(g => /^root-(system|lr)$/i.test(g)));
      if (disallowed.length > 0) {
        return {
          match: false, confidence: "high",
          detail: `Local account(s) using a disallowed group for the account-of-last-resort: ${disallowed.map(u => `${u.name} (group ${u.groups.join(",")})`).join("; ")} - this rule's own check text says root-system and root-lr should not be assigned to this account.`,
          evidence: disallowed.map(u => u.raw)
        };
      }
      if (users.length === 1) {
        return {
          status: "manual", confidence: "medium",
          detail: `Exactly one local account configured (${users[0].name}, group ${users[0].groups.join(",") || "none"}) - its group isn't one of the disallowed ones, but confirming it's the designated account-of-last-resort (and correctly ordered after the remote group in the login method list) requires manual review.`,
          evidence: [users[0].raw]
        };
      }
      return {
        status: "manual", confidence: "medium",
        detail: `Found ${users.length} local accounts: ${users.map(u => u.name).join(", ")}. None use a disallowed group, but more than one account still needs manual confirmation of which is the true account-of-last-resort.`,
        evidence: users.map(u => u.raw)
      };
    },

    "CISC-ND-000530": (cfg) => checkXRSshV2(cfg),
    "CISC-ND-001200": (cfg) => checkXRSshV2(cfg),
    "CISC-ND-001210": (cfg) => checkXRSshV2(cfg),

    "CISC-ND-000720": (cfg) => {
      // Unlike the switch NDM STIG's equivalent rule (V-220544), the
      // router version's check text only discusses line console/line
      // default exec-timeout - no HTTP timeout-policy component.
      const blocks = parseXRLineBlocks(cfg).filter(b => /^line\s+(console|default)\b/i.test(b.header));
      if (blocks.length === 0) {
        return { match: false, confidence: "high", detail: "No 'line console' or 'line default' blocks found to evaluate." };
      }
      const tooLong = [], evidence = [];
      let missing = 0;
      blocks.forEach(b => {
        const body = b.lines.join("\n");
        const m = body.match(/^\s*exec-timeout\s+(\d+)\s+(\d+)/im);
        if (m) {
          const min = parseInt(m[1], 10), sec = parseInt(m[2], 10);
          evidence.push(`${b.header}: exec-timeout ${min} ${sec}`);
          if (min > 5 || (min === 0 && sec === 0)) tooLong.push(`${b.header} (${min}:${sec})`);
        } else {
          missing++;
          evidence.push(`${b.header}: no exec-timeout set`);
        }
      });
      if (tooLong.length === 0 && missing === 0) {
        return { match: true, confidence: "high", detail: `All ${blocks.length} line console/default block(s) have exec-timeout configured <= 5 minutes.`, evidence };
      }
      const parts = [];
      if (missing > 0) parts.push(`${missing} block(s) with no exec-timeout at all`);
      if (tooLong.length > 0) parts.push(`exceeding 5 min or disabled: ${tooLong.join(", ")}`);
      return { match: false, confidence: "high", detail: "Issue(s): " + parts.join("; ") + ".", evidence };
    },

    "CISC-ND-000980": (cfg) => {
      const bufMatch = cfg.match(/^logging buffered\s+(\d+)/im);
      const archiveBlocks = parseConfigBlocks(cfg, /^logging archive\s*$/i);
      const hasArchive = archiveBlocks.length > 0 && /^\s*device\b/im.test(archiveBlocks[0].lines.join("\n"));
      if (bufMatch && hasArchive) {
        return { match: true, confidence: "high", detail: `Logging buffer size is set (${bufMatch[1]} bytes) and a 'logging archive' (persistent, on-disk) configuration is present.`, evidence: [`logging buffered ${bufMatch[1]}`, "logging archive ..."] };
      }
      const missing = [];
      if (!bufMatch) missing.push("'logging buffered <size>'");
      if (!hasArchive) missing.push("a 'logging archive' block with a 'device' target (persistent on-disk storage)");
      return { match: false, confidence: "high", detail: "Missing: " + missing.join(" and ") + "." };
    },

    "CISC-ND-001000": (cfg) => {
      const validLevels = ["critical", "error", "warning", "notice", "informational", "info", "alert", "emergency"];
      const withValidLevel = parseXRSyslogHosts(cfg).filter(h => h.severity && validLevels.includes(h.severity));
      return withValidLevel.length > 0
        ? { match: true, confidence: "high", detail: `Syslog host(s) configured with an explicit severity level (this rule's own note allows critical or any lesser level): ${withValidLevel.map(h => h.raw).join("; ")}.`, evidence: withValidLevel.map(h => h.raw) }
        : { match: false, confidence: "high", detail: "No syslog host with an explicit 'severity <level>' found." };
    },

    "CISC-ND-001030": (cfg) => {
      const ntpBody = parseXRNtpBlock(cfg);
      if (!ntpBody) return { match: false, confidence: "high", detail: "No 'ntp' configuration block found." };
      const servers = parseXRNtpServers(ntpBody);
      const uniqueAddrs = [...new Set(servers.map(s => s.address))];
      if (uniqueAddrs.length >= 2) return { match: true, confidence: "high", detail: `${uniqueAddrs.length} unique NTP server(s) configured: ${uniqueAddrs.join(", ")}.`, evidence: servers.map(s => s.raw) };
      if (uniqueAddrs.length === 1) return { match: false, confidence: "high", detail: `Only one unique NTP server configured (${uniqueAddrs[0]}); a redundant source is required.`, evidence: servers.map(s => s.raw) };
      return { match: false, confidence: "high", detail: "No 'server' statement found inside the 'ntp' block." };
    },

    "CISC-ND-001050": (cfg) => {
      const hasTimestamps = /^service timestamps log datetime\b/im.test(cfg);
      if (!hasTimestamps) return { match: false, confidence: "high", detail: "No 'service timestamps log datetime' statement found." };
      const tzMatch = cfg.match(/^clock timezone\s+(\S+)\s+([+-]?\d+)/im);
      if (tzMatch) {
        return { match: true, confidence: "high", detail: `Timestamps are enabled and an explicit UTC offset is configured ('clock timezone ${tzMatch[1]} ${tzMatch[2]}'), so records are mappable to UTC.`, evidence: [tzMatch[0].trim()] };
      }
      return { match: true, confidence: "high", detail: "Timestamps are enabled and no 'clock timezone' override is configured - per this rule's own note, UTC is the IOS-XR default in that case.", evidence: [] };
    },

    "CISC-ND-001130": (cfg) => {
      const users = parseXRSnmpV3Users(cfg);
      if (users.length === 0) return { status: "not_applicable", confidence: "high", detail: "No SNMPv3 users configured - if SNMP isn't used at all, this control doesn't apply; if it's used via v1/v2c instead, that's a separate, more serious finding." };
      const withAuth = users.filter(u => /\bauth\s+(md5|sha)\b/i.test(u.rest));
      return withAuth.length === users.length
        ? { match: true, confidence: "high", detail: `All ${users.length} SNMPv3 user(s) have an auth (HMAC) algorithm configured.`, evidence: users.map(u => u.raw) }
        : { match: false, confidence: "high", detail: `${users.length - withAuth.length} of ${users.length} SNMPv3 user(s) have no 'auth md5|sha' configured.`, evidence: users.map(u => u.raw) };
    },

    "CISC-ND-001140": (cfg) => {
      const users = parseXRSnmpV3Users(cfg);
      if (users.length === 0) return { status: "not_applicable", confidence: "high", detail: "No SNMPv3 users configured - if SNMP isn't used at all, this control doesn't apply." };
      const withAes = users.filter(u => /\bpriv\s+aes\b/i.test(u.rest));
      if (withAes.length === users.length) return { match: true, confidence: "high", detail: `All ${users.length} SNMPv3 user(s) use AES for privacy (encryption).`, evidence: users.map(u => u.raw) };
      const withWeakPriv = users.filter(u => /\bpriv\s+(des|3des)\b/i.test(u.rest));
      const withNoPriv = users.filter(u => !/\bpriv\b/i.test(u.rest));
      const problems = [];
      if (withWeakPriv.length) problems.push(`${withWeakPriv.length} using DES/3DES (not FIPS 140-2 approved)`);
      if (withNoPriv.length) problems.push(`${withNoPriv.length} with no 'priv' (encryption) configured at all`);
      return { match: false, confidence: "high", detail: "Issue(s): " + problems.join("; ") + ".", evidence: users.map(u => u.raw) };
    },

    "CISC-ND-001150": (cfg) => {
      const ntpBody = parseXRNtpBlock(cfg);
      if (!ntpBody) return { match: false, confidence: "high", detail: "No 'ntp' configuration block found." };
      const servers = parseXRNtpServers(ntpBody);
      if (servers.length === 0) return { match: false, confidence: "high", detail: "No 'server' statement found inside the 'ntp' block." };
      const authEnabled = /^\s*authenticate\s*$/im.test(ntpBody);
      if (!authEnabled) return { match: false, confidence: "high", detail: "'authenticate' is not set inside the 'ntp' block.", evidence: servers.map(s => s.raw) };
      const keyById = new Map(allMatches(ntpBody, /^\s*authentication-key\s+(\d+)\s+(\S+)/im).map(m => [m[1], m[2].toLowerCase()]));
      const trustedIds = new Set(allMatches(ntpBody, /^\s*trusted-key\s+(\d+)/im).map(m => m[1]));
      const unauthenticated = [], weak = [], compliant = [];
      servers.forEach(s => {
        if (!s.key) { unauthenticated.push(`${s.raw} (no key clause)`); return; }
        if (!trustedIds.has(s.key) || !keyById.has(s.key)) { unauthenticated.push(`${s.raw} (key ${s.key} not both defined and trusted)`); return; }
        const algo = keyById.get(s.key);
        if (/^md5/.test(algo)) weak.push(`${s.raw} (key ${s.key}, MD5)`);
        else compliant.push(`${s.raw} (key ${s.key}, ${algo})`);
      });
      if (unauthenticated.length) return { match: false, confidence: "high", detail: `Every configured NTP server must use a valid, trusted key. Issue(s): ${unauthenticated.join("; ")}.`, evidence: [...unauthenticated, ...weak, ...compliant] };
      if (weak.length) return { match: false, confidence: "high", detail: `${weak.length} server(s) use MD5 - unlike the switch NDM STIG's NTP rule, this rule's own check text only shows 'hmac-sha2' as compliant, so MD5 is a finding here: ${weak.join("; ")}.`, evidence: [...weak, ...compliant] };
      return { match: true, confidence: "high", detail: `NTP authentication is fully configured with a FIPS-compliant algorithm for every server: ${compliant.join("; ")}.`, evidence: compliant };
    },

    "CISC-ND-001310": (cfg) => {
      const hosts = parseXRSyslogHosts(cfg);
      return hosts.length > 0
        ? { match: true, confidence: "high", detail: `Log records are sent to an external syslog host: ${hosts.map(h => h.raw).join("; ")}.`, evidence: hosts.map(h => h.raw) }
        : { match: false, confidence: "high", detail: "No external syslog host ('logging <host> ...') found - logs aren't being off-loaded to a different system." };
    },

    "CISC-ND-001370": (cfg) => {
      const loginLines = allMatches(cfg, /^aaa authentication login\s+.*$/im).map(m => m[0].trim());
      const groupLines = loginLines.filter(l => /group\s+(radius|tacacs\+?)/i.test(l));
      if (groupLines.length === 0) {
        return { match: false, confidence: "high", detail: "No 'aaa authentication login' line references a radius/tacacs group.", evidence: loginLines };
      }
      const typesUsed = new Set();
      groupLines.forEach(l => { const gm = l.match(/group\s+(radius|tacacs\+?)/i); if (gm) typesUsed.add(gm[1].toLowerCase().replace("+", "")); });
      const radiusServers = parseXRAaaServers(cfg, "radius");
      const tacacsServers = parseXRAaaServers(cfg, "tacacs");
      const uniqueCount = list => new Set(list.map(s => s.address)).size;
      const evidence = [...groupLines];
      const problems = [];
      let satisfied = false;
      if (typesUsed.has("radius")) {
        evidence.push(...radiusServers.map(s => s.raw));
        if (uniqueCount(radiusServers) >= 2) satisfied = true;
        else problems.push(`RADIUS is used but only ${uniqueCount(radiusServers)} unique server(s) found via 'radius-server host' (need >= 2)`);
      }
      if (typesUsed.has("tacacs")) {
        evidence.push(...tacacsServers.map(s => s.raw));
        if (uniqueCount(tacacsServers) >= 2) satisfied = true;
        else problems.push(`TACACS+ is used but only ${uniqueCount(tacacsServers)} unique server(s) found via 'tacacs-server host' (need >= 2) - if this device defines TACACS+ servers a different way, verify manually`);
      }
      if (satisfied && problems.length === 0) {
        return { match: true, confidence: "high", detail: `Login method list resolves to at least one auth type backed by >= 2 servers. Order: ${groupLines.join(" | ")}.`, evidence };
      }
      return { match: false, confidence: "high", detail: "Issue(s): " + problems.join("; "), evidence };
    },

    "CISC-ND-001410": (cfg) => {
      return /^configuration commit auto-save\b/im.test(cfg)
        ? { match: true, confidence: "high", detail: "'configuration commit auto-save' is configured, automatically backing up the configuration on every commit." }
        : { match: false, confidence: "medium", detail: "No 'configuration commit auto-save' statement found. This is the one specific mechanism this rule's check text shows - if backups are handled a different way (e.g. an external change-management system), verify manually." };
    },

    "CISC-ND-001440": (cfg) => {
      const hasTrustpoint = /^crypto (pki|ca) trustpoint\b/im.test(cfg);
      if (!hasTrustpoint) {
        return { status: "not_applicable", confidence: "medium", detail: "No 'crypto pki trustpoint' (or legacy 'crypto ca trustpoint') found - per this rule's own note, it doesn't apply if the router has no public key certificates. Verify no certificate-based services are actually in use." };
      }
      return {
        status: "manual", confidence: "medium",
        detail: "A CA trustpoint is configured - a human needs to verify the CA is a DoD or DoD-approved CA, which a config file alone can't confirm.",
        evidence: allMatches(cfg, /^crypto (pki|ca) trustpoint\s+\S+/im).map(m => m[0].trim())
      };
    },

    "CISC-ND-001450": (cfg) => {
      const uniqueAddrs = [...new Set(parseXRSyslogHosts(cfg).map(h => h.address))];
      const hosts = parseXRSyslogHosts(cfg);
      if (uniqueAddrs.length >= 2) return { match: true, confidence: "high", detail: `${uniqueAddrs.length} unique syslog server(s) configured: ${uniqueAddrs.join(", ")}.`, evidence: hosts.map(h => h.raw) };
      if (uniqueAddrs.length === 1) return { match: false, confidence: "high", detail: `Only one unique syslog server configured (${uniqueAddrs[0]}); at least two are required.`, evidence: hosts.map(h => h.raw) };
      return { match: false, confidence: "high", detail: "No syslog host destination found." };
    },

    // --- RTR (routing / traffic-plane security) ---
    "CISC-RT-000070": (cfg) => checkXRUnnecessaryServices(cfg, false),

    "CISC-RT-000140": (cfg) => {
      const found = allMatches(cfg, /^\s*\d+\s+deny\s+icmp\s+.*\bfragments\b.*$/gim).map(m => m[0].trim());
      if (found.length === 0) {
        return { match: false, confidence: "medium", detail: "No ACL 'deny icmp ... fragments' statement found anywhere - fragmented ICMP destined to the router doesn't appear to be dropped." };
      }
      return {
        status: "manual", confidence: "low",
        detail: `Found ${found.length} 'deny icmp ... fragments' statement(s), but this rule's check text also requires the deny come BEFORE any permit-icmp statements in the same ACL, which can't be verified generically - confirm the ordering manually: ${found.join("; ")}`,
        evidence: found
      };
    },

    "CISC-RT-000160": (cfg) => {
      const blocks = parseXRInterfaceBlocks(cfg);
      if (blocks.length === 0) return { match: false, confidence: "high", detail: "No 'interface' blocks found to evaluate." };
      const bad = blocks.filter(b => /^\s*ipv4 directed-broadcast\b/im.test(b.lines.join("\n")));
      return bad.length === 0
        ? { match: true, confidence: "high", detail: `None of the ${blocks.length} interface(s) have 'ipv4 directed-broadcast' enabled.` }
        : { match: false, confidence: "high", detail: `'ipv4 directed-broadcast' is enabled on: ${bad.map(b => b.header).join(", ")}.`, evidence: bad.map(b => b.header) };
    },

    "CISC-RT-000170": (cfg) => {
      const candidates = findLikelyExternalInterfaces(cfg);
      if (candidates.length === 0) {
        return { status: "manual", confidence: "low", detail: "Couldn't identify any likely-external interface from description text - verify 'ipv4 unreachables disable' manually on untrusted-facing interfaces." };
      }
      const missing = candidates.filter(b => !/^\s*ipv4 unreachables disable\b/im.test(b.lines.join("\n")));
      return missing.length === 0
        ? { match: true, confidence: "medium", detail: `All ${candidates.length} likely-external interface(s) have 'ipv4 unreachables disable'.`, evidence: candidates.map(b => b.header) }
        : { match: false, confidence: "medium", detail: `Missing 'ipv4 unreachables disable' on likely-external interface(s): ${missing.map(b => b.header).join(", ")}.`, evidence: missing.map(b => b.header) };
    },

    "CISC-RT-000180": (cfg) => checkXRExternalIfaceAbsence(cfg, /^\s*ipv4 mask-reply\b/im, "'ipv4 mask-reply'"),
    "CISC-RT-000190": (cfg) => checkXRExternalIfaceAbsence(cfg, /^\s*ipv4 redirects\b/im, "'ipv4 redirects'"),

    "CISC-RT-000200": (cfg) => checkXRAclAnyLog(cfg),
    "CISC-RT-000210": (cfg) => checkXRAclLogInput(cfg),
    "CISC-RT-000220": (cfg) => checkXRAclLogInput(cfg),

    "CISC-RT-000350": (cfg) => {
      return /^ipv4 source-route\b/im.test(cfg)
        ? { match: false, confidence: "high", detail: "'ipv4 source-route' is explicitly enabled - this should not be configured (IOS XR drops all IP-option packets except source-route by default, so source-route itself must stay disabled)." }
        : { match: true, confidence: "high", detail: "'ipv4 source-route' is not configured - IOS XR's default (disabled) applies." };
    },

    "CISC-RT-000360": (cfg) => {
      const lldpGlobal = /^lldp\s*$/im.test(cfg);
      if (!lldpGlobal) {
        return { match: true, confidence: "high", detail: "LLDP is not enabled globally ('lldp' not found) - disabled by default, so no interface can be transmitting LLDP." };
      }
      const candidates = findLikelyExternalInterfaces(cfg);
      if (candidates.length === 0) {
        return { status: "manual", confidence: "low", detail: "LLDP is enabled globally, but no likely-external interface could be identified from description text - verify 'lldp / transmit disable' manually on untrusted-facing interfaces." };
      }
      const missing = candidates.filter(b => !/^\s*lldp\b[\s\S]*?transmit disable/im.test(b.lines.join("\n")));
      return missing.length === 0
        ? { match: true, confidence: "medium", detail: `LLDP is enabled globally, but all ${candidates.length} likely-external interface(s) have transmit disabled.`, evidence: candidates.map(b => b.header) }
        : { match: false, confidence: "medium", detail: `LLDP is enabled globally and transmit is NOT disabled on likely-external interface(s): ${missing.map(b => b.header).join(", ")}.`, evidence: missing.map(b => b.header) };
    },

    "CISC-RT-000370": (cfg) => checkXRExternalIfaceAbsence(cfg, /^\s*cdp\b/im, "CDP"),
    "CISC-RT-000380": (cfg) => checkXRExternalIfaceAbsence(cfg, /^\s*proxy-arp\b/im, "Proxy ARP")
  };

  // -------------------------------------------------------------------
  // Router-platform risky/opt-in checks. Same "off by default, opt in
  // once you've judged the trade-off" pattern as the switch platform's
  // RISKY_RULES - here the common thread is the description-keyword
  // heuristic used to guess which interfaces are "external" (IOS-XR has
  // no config-level flag for this), plus one rule whose only detectable
  // signal is a single specific command that might not be the only valid
  // way to satisfy the requirement.
  // -------------------------------------------------------------------
  const ROUTER_RISKY_RULES = [
    {
      id: "CISC-ND-001410",
      label: "Configuration Backup on Change",
      blurb: "The only mechanism this rule's check text shows is 'configuration commit auto-save' - if backups are actually handled through an external change-management or backup system instead, a device using that would be incorrectly flagged Open."
    },
    {
      id: "CISC-RT-000140",
      label: "Fragmented ICMP Dropped",
      blurb: "Presence of a 'deny icmp ... fragments' ACL line is checked, but this rule also requires that deny come BEFORE any permit-icmp statement in the same ACL - ordering can't be verified generically, so a present-but-misordered rule would be missed."
    },
    {
      id: "CISC-RT-000170",
      label: "ICMP Unreachables Disabled (External Interfaces)",
      blurb: "Relies on a description-keyword heuristic (WAN/external/untrusted/outside/uplink/edge/perimeter/DMZ) to guess which interfaces are external, since IOS-XR has no config-level flag for this - a genuinely external interface with an unmatched description is invisible to this check."
    },
    {
      id: "CISC-RT-000180",
      label: "ICMP Mask-Reply Disabled (External Interfaces)",
      blurb: "Same external-interface description-keyword heuristic as the ICMP Unreachables check above, with the same blind spot."
    },
    {
      id: "CISC-RT-000190",
      label: "ICMP Redirects Disabled (External Interfaces)",
      blurb: "Same external-interface description-keyword heuristic as the ICMP Unreachables check above, with the same blind spot."
    },
    {
      id: "CISC-RT-000360",
      label: "LLDP Disabled (External Interfaces)",
      blurb: "Same external-interface description-keyword heuristic as the ICMP checks above, with the same blind spot."
    },
    {
      id: "CISC-RT-000370",
      label: "CDP Disabled (External Interfaces)",
      blurb: "Same external-interface description-keyword heuristic as the ICMP checks above, with the same blind spot."
    },
    {
      id: "CISC-RT-000380",
      label: "Proxy ARP Disabled (External Interfaces)",
      blurb: "Same external-interface description-keyword heuristic as the ICMP checks above, with the same blind spot."
    }
  ];

  // =====================================================================
  // JUNIPER PLATFORM (Junos Router NDM + RTR STIGs)
  // =====================================================================
  // Junos configs are a hierarchical curly-brace tree ("system { login {
  // retry-options { tries-before-disconnect 3; } } }"), not line-oriented
  // IOS-style commands - none of the IOS parseConfigBlocks-family helpers
  // apply here at all. Rule IDs use their own "JUNI-ND-"/"JUNI-RT-" prefix
  // (no collision with Cisco's "CISC-ND-"/"CISC-RT-"), but get their own
  // table anyway for the same organizational clarity as the router split.
  // =====================================================================

  // Generic brace-depth block extractor for Junos config text. Given a
  // header regex tested against each line individually (so it matches
  // regardless of nesting depth), finds the matching closing "}" by
  // counting braces line by line and returns the body between them. Works
  // on any text snippet, including another block's own body - so nested
  // extraction (e.g. "class" blocks inside a "login" block) is just two
  // calls, not a bespoke recursive-descent parser.
  // Known limitation: doesn't special-case braces inside quoted strings
  // (e.g. a login banner). None of the strings in these particular rules'
  // relevant statements contain literal brace characters, so this hasn't
  // been an issue in practice, but a config that put a "{" inside a
  // quoted message could throw off the depth count.
  function parseJunosBlocks(cfg, headerRegex) {
    const lines = cfg.split(/\r?\n/);
    const blocks = [];
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      if (!headerRegex.test(line) || !/\{\s*$/.test(line.trim())) continue;
      let depth = 1;
      const bodyLines = [];
      let j = i + 1;
      for (; j < lines.length && depth > 0; j++) {
        const l = lines[j];
        const opens = (l.match(/\{/g) || []).length;
        const closes = (l.match(/\}/g) || []).length;
        depth += opens - closes;
        if (depth > 0) {
          bodyLines.push(l);
        } else if (depth === 0) {
          const beforeClose = l.slice(0, l.lastIndexOf("}"));
          if (beforeClose.trim()) bodyLines.push(beforeClose);
        }
      }
      blocks.push({ header: line.trim(), lines: bodyLines, raw: bodyLines.join("\n") });
      i = j - 1;
    }
    return blocks;
  }

  function findJunosLoginBlocks(cfg) {
    return parseJunosBlocks(cfg, /^\s*login\s*\{/i);
  }

  function parseJunosLoginClasses(cfg) {
    const classes = [];
    findJunosLoginBlocks(cfg).forEach(lb => {
      parseJunosBlocks(lb.raw, /^\s*class\s+\S+\s*\{/i).forEach(cb => {
        const hm = cb.header.match(/^\s*class\s+(\S+)/i);
        const idleMatch = cb.raw.match(/^\s*idle-timeout\s+(\d+);/im);
        classes.push({ name: hm[1], idleTimeout: idleMatch ? parseInt(idleMatch[1], 10) : null, raw: cb.header });
      });
    });
    return classes;
  }

  function parseJunosUsers(cfg) {
    const users = [];
    findJunosLoginBlocks(cfg).forEach(lb => {
      parseJunosBlocks(lb.raw, /^\s*user\s+\S+\s*\{/i).forEach(ub => {
        const hm = ub.header.match(/^\s*user\s+(\S+)/i);
        const classMatch = ub.raw.match(/^\s*class\s+(\S+);/im);
        users.push({ name: hm[1], className: classMatch ? classMatch[1] : null, raw: ub.header });
      });
    });
    return users;
  }

  // "user NAME { authentication-sha {...} }" also matches the login-user
  // block shape above, so SNMPv3 users are distinguished by requiring an
  // authentication-*/privacy-* sub-block, which a login user never has.
  function parseJunosSnmpV3Users(cfg) {
    return parseJunosBlocks(cfg, /^\s*user\s+\S+\s*\{/i)
      .filter(b => /authentication-(sha|md5)\b/i.test(b.raw))
      .map(b => {
        const hm = b.header.match(/^\s*user\s+(\S+)/i);
        const authMatch = b.raw.match(/authentication-(sha|md5)\b/i);
        const privMatch = b.raw.match(/privacy-(aes\d*|des|3des)\b/i);
        return { name: hm[1], authAlgo: authMatch ? authMatch[1].toLowerCase() : null, privAlgo: privMatch ? privMatch[1].toLowerCase() : null, raw: b.header };
      });
  }

  function parseJunosNtpBlock(cfg) {
    const blocks = parseJunosBlocks(cfg, /^\s*ntp\s*\{/i);
    return blocks.length ? blocks[0].raw : "";
  }
  function parseJunosNtpServers(ntpBody) {
    return allMatches(ntpBody, /^\s*server\s+(\S+)(.*);/im).map(m => {
      const rest = m[2] || "";
      const keyMatch = rest.match(/\bkey\s+(\d+)/i);
      return { raw: m[0].trim(), address: m[1], key: keyMatch ? keyMatch[1] : null };
    });
  }
  function parseJunosNtpTrustedKeys(ntpBody) {
    const m = ntpBody.match(/^\s*trusted-key\s+(?:\[([^\]]*)\]|(\d+));/im);
    if (!m) return new Set();
    return new Set((m[1] || m[2] || "").split(/\s+/).filter(Boolean));
  }

  // "host <addr> { ... }" syslog destinations specifically (not "file" or
  // "console" destinations) - used by the >=2-servers and alert-severity
  // rules, which are both specifically about EXTERNAL syslog hosts.
  function parseJunosSyslogHosts(cfg) {
    return parseJunosBlocks(cfg, /^\s*host\s+\S+\s*\{/i).map(b => {
      const hm = b.header.match(/^\s*host\s+(\S+)/i);
      const sevMatch = b.raw.match(/^\s*(?:any|change-log|authorization|interactive-commands|firewall)\s+([a-zA-Z]+);/im);
      return { address: hm[1], raw: b.header, severity: sevMatch ? sevMatch[1].toLowerCase() : null };
    });
  }

  // Shared by the large cluster of Junos audit-logging rules that all
  // reduce to "does SOME syslog destination log this event class (or
  // 'any', which is an accepted superset per every one of these rules'
  // own check text)". requireAll distinguishes the couple of rules whose
  // own example shows TWO classes together (e.g. change-log AND
  // interactive-commands) from the majority that accept any ONE of an
  // acceptable set.
  function checkJunosAuditEvent(cfg, classNames, activityLabel, requireAll) {
    const anyLine = cfg.match(/^\s*any\s+[a-zA-Z]+;/im);
    if (anyLine) {
      return { match: true, confidence: "high", detail: `A syslog destination logs 'any' (everything) - satisfies ${activityLabel} per this rule's own check text.`, evidence: [anyLine[0].trim()] };
    }
    const foundPerClass = classNames.map(c => {
      const m = cfg.match(new RegExp(`^\\s*${c}\\s+[a-zA-Z]+;`, "im"));
      return m ? m[0].trim() : null;
    });
    const ok = requireAll ? foundPerClass.every(Boolean) : foundPerClass.some(Boolean);
    if (ok) {
      return { match: true, confidence: "high", detail: `Syslog destination logs ${foundPerClass.filter(Boolean).join(", ")} - satisfies ${activityLabel}.`, evidence: foundPerClass.filter(Boolean) };
    }
    return { match: false, confidence: "high", detail: `No syslog destination found logging ${requireAll ? "all of" : "any of"} '${classNames.join("', '")}' (or 'any') - ${activityLabel} isn't being audited.` };
  }

  const JUNOS_PW_REQUIREMENTS = {
    "JUNI-ND-000550": { key: "minimum-length", min: 15 },
    "JUNI-ND-000570": { key: "minimum-upper-cases", min: 1 },
    "JUNI-ND-000580": { key: "minimum-lower-cases", min: 1 },
    "JUNI-ND-000590": { key: "minimum-numerics", min: 1 },
    "JUNI-ND-000600": { key: "minimum-punctuations", min: 1 }
  };
  function checkJunosPasswordReq(cfg, ruleId) {
    const req = JUNOS_PW_REQUIREMENTS[ruleId];
    const m = cfg.match(new RegExp(`${req.key}\\s+(\\d+);`, "i"));
    if (!m) return { match: false, confidence: "high", detail: `No '${req.key} <n>;' found in the password policy.` };
    const val = parseInt(m[1], 10);
    return val >= req.min
      ? { match: true, confidence: "high", detail: `Password policy '${req.key}' is ${val} (>= ${req.min} required).`, evidence: [m[0].trim()] }
      : { match: false, confidence: "high", detail: `Password policy '${req.key}' is ${val} (< ${req.min} required).`, evidence: [m[0].trim()] };
  }

  // Shared by every rule whose real detectable signal is "does the
  // loopback interface (the Routing Engine's receive path) have an input
  // filter applied at all" - NDM's management-flow-control and DoS-
  // protection rules, and RT's restrict-traffic-to-self rule. What the
  // filter's TERMS actually do (permit only the right sources, police the
  // right protocols, etc.) can't be verified generically, so presence
  // defers to manual review rather than an automatic pass.
  function checkJunosLoopbackFilterPresence(cfg, activityLabel) {
    const lo0Blocks = parseJunosBlocks(cfg, /^\s*lo0\s*\{/i);
    if (lo0Blocks.length === 0) {
      return { match: false, confidence: "medium", detail: "No 'lo0' (loopback) interface block found - the Routing Engine's receive path isn't protected by an input filter." };
    }
    const hasFilter = lo0Blocks.some(b => /^\s*input\s+\S+;/im.test(b.raw));
    if (!hasFilter) {
      return { match: false, confidence: "medium", detail: `No 'filter { input ...; }' found under 'lo0' - ${activityLabel} isn't restricted.` };
    }
    const filterNames = allMatches(lo0Blocks.map(b => b.raw).join("\n"), /^\s*input\s+(\S+);/im).map(m => m[1]);
    return {
      status: "manual", confidence: "medium",
      detail: `'lo0' has an input filter applied (${[...new Set(filterNames)].join(", ")}) - a human needs to verify its terms actually ${activityLabel}, since filter content can't be evaluated generically.`,
      evidence: lo0Blocks.map(b => b.header)
    };
  }

  function parseJunosFirewallFilters(cfg) {
    return parseJunosBlocks(cfg, /^\s*filter\s+\S+\s*\{/i);
  }

  // Shared by the three Junos rules that all reduce to "every discard/
  // reject term across every firewall filter must include a log/syslog
  // action."
  function checkJunosFilterLogging(cfg) {
    const filters = parseJunosFirewallFilters(cfg);
    if (filters.length === 0) return { status: "manual", confidence: "medium", detail: "No 'filter NAME { ... }' firewall blocks found to evaluate." };
    const terms = [];
    filters.forEach(f => {
      parseJunosBlocks(f.raw, /^\s*term\s+\S+\s*\{/i).forEach(t => {
        if (/\b(discard|reject)\b/i.test(t.raw)) {
          terms.push({ filter: f.header, term: t.header, hasLog: /\b(log|syslog)\s*;/i.test(t.raw) });
        }
      });
    });
    if (terms.length === 0) return { status: "manual", confidence: "medium", detail: "No discard/reject terms found in any firewall filter to evaluate." };
    const unlogged = terms.filter(t => !t.hasLog);
    if (unlogged.length === 0) {
      return { match: true, confidence: "high", detail: `All ${terms.length} discard/reject term(s) across firewall filters include a 'log' or 'syslog' action.`, evidence: terms.map(t => `${t.filter} / ${t.term}`) };
    }
    return { match: false, confidence: "high", detail: `${unlogged.length} of ${terms.length} discard/reject term(s) have no 'log'/'syslog' action: ${unlogged.map(t => `${t.filter} / ${t.term}`).join("; ")}`, evidence: terms.map(t => `${t.filter} / ${t.term}`) };
  }

  // Same description-keyword heuristic as the Cisco router platform's
  // "external interface" checks, and the same residual blind spot -
  // every rule using this is opt-in via JUNIPER_RISKY_RULES.
  const JUNOS_EXTERNAL_IFACE_KEYWORDS = /\b(wan|external|untrusted|outside|internet|edge|uplink|perimeter|dmz)\b/i;
  function findLikelyExternalJunosInterfaces(cfg) {
    // Junos interface names (e.g. "ge-0/0/0") aren't matched by a simple
    // "\S+" the way IOS interface names are - this still works fine since
    // \S+ has no trouble with the slashes/dashes in a Junos ifname.
    return parseJunosBlocks(cfg, /^\s*[a-z]+-?[\d/.:]*\s*\{/i).filter(b => {
      const descMatch = b.raw.match(/^\s*description\s+"?([^;"]*)"?;/im);
      return descMatch && JUNOS_EXTERNAL_IFACE_KEYWORDS.test(descMatch[1]);
    });
  }

  const JUNIPER_RULE_CHECKS = {
    // --- NDM ---
    "JUNI-ND-000010": (cfg) => {
      const m = cfg.match(/connection-limit\s+(\d+);/i);
      return m
        ? { match: true, confidence: "high", detail: `'connection-limit ${m[1]};' is configured under SSH, limiting concurrent sessions.`, evidence: [m[0].trim()] }
        : { match: false, confidence: "high", detail: "No 'connection-limit <n>;' found under the SSH service - concurrent sessions are not limited." };
    },

    "JUNI-ND-000090": (cfg) => checkJunosAuditEvent(cfg, ["change-log"], "account creation"),
    "JUNI-ND-000100": (cfg) => checkJunosAuditEvent(cfg, ["change-log"], "account modification"),
    "JUNI-ND-000110": (cfg) => checkJunosAuditEvent(cfg, ["change-log"], "account disabling"),
    "JUNI-ND-000120": (cfg) => checkJunosAuditEvent(cfg, ["change-log"], "account removal"),

    "JUNI-ND-000140": (cfg) => checkJunosLoopbackFilterPresence(cfg, "restricts management traffic to approved sources"),

    "JUNI-ND-000150": (cfg) => {
      const triesMatch = cfg.match(/tries-before-disconnect\s+(\d+);/i);
      const lockoutMatch = cfg.match(/lockout-period\s+(\d+);/i);
      if (!triesMatch || !lockoutMatch) {
        const missing = [];
        if (!triesMatch) missing.push("'tries-before-disconnect <n>;'");
        if (!lockoutMatch) missing.push("'lockout-period <n>;'");
        return { match: false, confidence: "high", detail: "Missing: " + missing.join(" and ") + "." };
      }
      const tries = parseInt(triesMatch[1], 10), lockout = parseInt(lockoutMatch[1], 10);
      if (tries <= 3 && lockout >= 15) {
        return { match: true, confidence: "high", detail: `'tries-before-disconnect ${tries};' and 'lockout-period ${lockout};' meet the 3-attempt / 15-minute requirement.`, evidence: [triesMatch[0].trim(), lockoutMatch[0].trim()] };
      }
      return { match: false, confidence: "high", detail: `'tries-before-disconnect ${tries};' (need <= 3) and 'lockout-period ${lockout};' (need >= 15) don't both meet the requirement.`, evidence: [triesMatch[0].trim(), lockoutMatch[0].trim()] };
    },

    "JUNI-ND-000160": (cfg) => {
      const m = cfg.match(/^\s*message\s+"([^"]*)";/im);
      if (!m || !m[1].trim()) {
        return { match: false, confidence: "high", detail: "No 'message \"...\";' found under login - no login banner is configured." };
      }
      let bannerText = m[1].replace(/\\n/g, " / ").trim();
      if (bannerText.length > 200) bannerText = bannerText.slice(0, 200) + "...";
      return {
        status: "manual", confidence: "medium",
        detail: "A login banner message is configured - verify the exact text matches the DoD-mandated Standard Mandatory Notice and Consent wording (this cannot be verified by pattern matching alone).",
        evidence: [`message: "${bannerText}"`]
      };
    },

    "JUNI-ND-000210": (cfg) => checkJunosAuditEvent(cfg, ["change-log"], "non-repudiation of configuration changes"),
    "JUNI-ND-000250": (cfg) => checkJunosAuditEvent(cfg, ["authorization"], "logon attempt auditing"),
    "JUNI-ND-000330": (cfg) => checkJunosAuditEvent(cfg, ["change-log"], "full-text recording of privileged commands"),

    "JUNI-ND-000470": (cfg) => {
      const bad = [
        { re: /^\s*finger;/im, label: "finger" },
        { re: /^\s*telnet;/im, label: "telnet" },
        { re: /^\s*xnm-clear-text;/im, label: "xnm-clear-text" },
        { re: /^\s*ftp;/im, label: "ftp" }
      ];
      const found = bad.filter(b => b.re.test(cfg)).map(b => b.label);
      const conditional = [];
      if (/^\s*web-management\s*\{/im.test(cfg)) conditional.push("web-management (J-Web) - only acceptable if operationally required");
      if (/^\s*dhcp-local-server\s*\{/im.test(cfg)) conditional.push("dhcp-local-server - only acceptable if this router is actually a DHCP server");
      if (found.length > 0) {
        return { match: false, confidence: "high", detail: "Unnecessary/non-secure service(s) enabled: " + found.join(", ") + "." + (conditional.length ? " Also present (conditionally acceptable, verify need): " + conditional.join("; ") + "." : "") };
      }
      if (conditional.length > 0) {
        return { status: "manual", confidence: "medium", detail: "None of the always-prohibited services (finger/telnet/xnm-clear-text/ftp) are enabled, but conditionally-acceptable service(s) are present and need justification: " + conditional.join("; ") + "." };
      }
      return { match: true, confidence: "high", detail: "None of the unnecessary/non-secure services checked were found enabled." };
    },

    "JUNI-ND-000490": (cfg) => {
      const users = parseJunosUsers(cfg);
      if (users.length === 0) return { match: false, confidence: "high", detail: "No local user accounts found under login; an account-of-last-resort is required." };
      if (users.length === 1) {
        return { status: "manual", confidence: "medium", detail: `Exactly one local account configured (${users[0].name}, class ${users[0].className || "unknown"}) - matches the minimal expected case, but confirming it's the documented account-of-last-resort requires manual review.`, evidence: [users[0].raw] };
      }
      return { status: "manual", confidence: "medium", detail: `Found ${users.length} local accounts: ${users.map(u => u.name).join(", ")}. More than one isn't automatically a finding, but needs manual confirmation of which is the true account-of-last-resort.`, evidence: users.map(u => u.raw) };
    },

    "JUNI-ND-000530": (cfg) => {
      return /^\s*macs\b/im.test(cfg)
        ? { match: true, confidence: "high", detail: "An explicit 'macs [...]' restriction is configured under SSH.", evidence: [cfg.match(/^\s*macs\b.*$/im)[0].trim()] }
        : { match: false, confidence: "high", detail: "No explicit 'macs [...]' restriction found under SSH - this rule's check text gives no basis for assuming a safe default here." };
    },

    "JUNI-ND-000550": (cfg) => checkJunosPasswordReq(cfg, "JUNI-ND-000550"),
    "JUNI-ND-000570": (cfg) => checkJunosPasswordReq(cfg, "JUNI-ND-000570"),
    "JUNI-ND-000580": (cfg) => checkJunosPasswordReq(cfg, "JUNI-ND-000580"),
    "JUNI-ND-000590": (cfg) => checkJunosPasswordReq(cfg, "JUNI-ND-000590"),
    "JUNI-ND-000600": (cfg) => checkJunosPasswordReq(cfg, "JUNI-ND-000600"),

    "JUNI-ND-000710": (cfg) => {
      const classes = parseJunosLoginClasses(cfg);
      if (classes.length === 0) return { status: "manual", confidence: "medium", detail: "No login 'class { ... }' blocks found to evaluate idle-timeout." };
      const bad = classes.filter(c => c.idleTimeout === null || c.idleTimeout > 5);
      if (bad.length === 0) {
        return { match: true, confidence: "high", detail: `All ${classes.length} login class(es) have idle-timeout <= 5 minutes.`, evidence: classes.map(c => `${c.name}: idle-timeout ${c.idleTimeout}`) };
      }
      return { match: false, confidence: "high", detail: `Login class(es) with idle-timeout > 5 min or unset: ${bad.map(c => `${c.name} (${c.idleTimeout ?? "unset"})`).join(", ")}.`, evidence: classes.map(c => `${c.name}: idle-timeout ${c.idleTimeout}`) };
    },

    "JUNI-ND-000870": (cfg) => checkJunosAuditEvent(cfg, ["change-log"], "account enabling"),
    "JUNI-ND-000930": (cfg) => checkJunosAuditEvent(cfg, ["interactive-commands", "change-log"], "execution of privileged functions", true),

    "JUNI-ND-000970": (cfg) => {
      return /archive\s+size\s+\S+\s+files\s+\d+;/i.test(cfg)
        ? { match: true, confidence: "high", detail: "An 'archive size ... files ...;' setting is configured, allocating audit-log storage capacity.", evidence: [cfg.match(/archive\s+size\s+\S+\s+files\s+\d+;/i)[0].trim()] }
        : { match: false, confidence: "high", detail: "No 'archive size ... files ...;' setting found under syslog." };
    },

    "JUNI-ND-000990": (cfg) => {
      const validLevels = ["critical", "error", "warning", "notice", "info", "alert", "emergency"];
      const withValidLevel = parseJunosSyslogHosts(cfg).filter(h => h.severity && validLevels.includes(h.severity));
      return withValidLevel.length > 0
        ? { match: true, confidence: "high", detail: `Syslog host(s) configured with an explicit severity level (this rule's own note allows critical or any lesser level): ${withValidLevel.map(h => h.raw).join("; ")}.`, evidence: withValidLevel.map(h => h.raw) }
        : { match: false, confidence: "high", detail: "No syslog host with an explicit severity level found." };
    },

    "JUNI-ND-001020": (cfg) => {
      const ntpBody = parseJunosNtpBlock(cfg);
      if (!ntpBody) return { match: false, confidence: "high", detail: "No 'ntp { ... }' block found." };
      const servers = parseJunosNtpServers(ntpBody);
      const uniqueAddrs = [...new Set(servers.map(s => s.address))];
      if (uniqueAddrs.length >= 2) return { match: true, confidence: "high", detail: `${uniqueAddrs.length} unique NTP server(s) configured: ${uniqueAddrs.join(", ")}.`, evidence: servers.map(s => s.raw) };
      if (uniqueAddrs.length === 1) return { match: false, confidence: "high", detail: `Only one unique NTP server configured (${uniqueAddrs[0]}); a redundant source is required.`, evidence: servers.map(s => s.raw) };
      return { match: false, confidence: "high", detail: "No 'server' statement found inside the 'ntp' block." };
    },

    "JUNI-ND-001030": (cfg) => {
      const m = cfg.match(/^\s*time-zone\s+(\S+);/im);
      return { match: true, confidence: "high", detail: m ? `Explicit timezone configured ('time-zone ${m[1]};'), and per this rule's own note UTC is the Junos default regardless.` : "No 'time-zone' override configured - per this rule's own note, UTC is the Junos default in that case." };
    },

    "JUNI-ND-001120": (cfg) => {
      const users = parseJunosSnmpV3Users(cfg);
      if (users.length === 0) return { status: "not_applicable", confidence: "high", detail: "No SNMPv3 users configured - if SNMP isn't used at all, this control doesn't apply." };
      return users.every(u => u.authAlgo)
        ? { match: true, confidence: "high", detail: `All ${users.length} SNMPv3 user(s) have an authentication-sha/md5 block configured.`, evidence: users.map(u => u.raw) }
        : { match: false, confidence: "high", detail: `${users.filter(u => !u.authAlgo).length} of ${users.length} SNMPv3 user(s) have no authentication-sha/md5 block.`, evidence: users.map(u => u.raw) };
    },
    "JUNI-ND-001130": (cfg) => {
      const users = parseJunosSnmpV3Users(cfg);
      if (users.length === 0) return { status: "not_applicable", confidence: "high", detail: "No SNMPv3 users configured - if SNMP isn't used at all, this control doesn't apply." };
      const withAes = users.filter(u => u.privAlgo && /^aes/.test(u.privAlgo));
      if (withAes.length === users.length) return { match: true, confidence: "high", detail: `All ${users.length} SNMPv3 user(s) use an AES privacy-* block.`, evidence: users.map(u => u.raw) };
      const withWeak = users.filter(u => u.privAlgo && !/^aes/.test(u.privAlgo));
      const withNone = users.filter(u => !u.privAlgo);
      const problems = [];
      if (withWeak.length) problems.push(`${withWeak.length} using DES/3DES (not FIPS 140-2 approved)`);
      if (withNone.length) problems.push(`${withNone.length} with no privacy-* block at all`);
      return { match: false, confidence: "high", detail: "Issue(s): " + problems.join("; ") + ".", evidence: users.map(u => u.raw) };
    },

    "JUNI-ND-001140": (cfg) => {
      const ntpBody = parseJunosNtpBlock(cfg);
      if (!ntpBody) return { match: false, confidence: "high", detail: "No 'ntp { ... }' block found." };
      const servers = parseJunosNtpServers(ntpBody);
      if (servers.length === 0) return { match: false, confidence: "high", detail: "No 'server' statement found inside the 'ntp' block." };
      const trustedKeys = parseJunosNtpTrustedKeys(ntpBody);
      const keyDefined = new Set(allMatches(ntpBody, /^\s*authentication-key\s+(\d+)\s+type\s+\S+/im).map(m => m[1]));
      const unauthenticated = [];
      servers.forEach(s => {
        if (!s.key) { unauthenticated.push(`${s.raw} (no key clause)`); return; }
        if (!trustedKeys.has(s.key) || !keyDefined.has(s.key)) unauthenticated.push(`${s.raw} (key ${s.key} not both defined and trusted)`);
      });
      if (unauthenticated.length > 0) {
        return { match: false, confidence: "high", detail: `Every configured NTP server must use a valid, trusted authentication key. Issue(s): ${unauthenticated.join("; ")}.`, evidence: servers.map(s => s.raw) };
      }
      return { match: true, confidence: "high", detail: "NTP authentication is configured for every server (this rule's own check text accepts MD5-based keys - unlike some other platforms' equivalent rule, Junos's own example uses MD5 without caveat).", evidence: servers.map(s => s.raw) };
    },

    "JUNI-ND-001190": (cfg) => {
      return /^\s*macs\b/im.test(cfg)
        ? { match: true, confidence: "high", detail: "An explicit 'macs [...]' restriction is configured under SSH.", evidence: [cfg.match(/^\s*macs\b.*$/im)[0].trim()] }
        : { match: false, confidence: "high", detail: "No explicit 'macs [...]' restriction found under SSH." };
    },
    "JUNI-ND-001200": (cfg) => {
      return /^\s*ciphers\b/im.test(cfg)
        ? { match: true, confidence: "high", detail: "An explicit 'ciphers [...]' restriction is configured under SSH.", evidence: [cfg.match(/^\s*ciphers\b.*$/im)[0].trim()] }
        : { match: false, confidence: "high", detail: "No explicit 'ciphers [...]' restriction found under SSH." };
    },

    "JUNI-ND-001210": (cfg) => checkJunosLoopbackFilterPresence(cfg, "protects against denial-of-service via control plane protection"),

    "JUNI-ND-001230": (cfg) => checkJunosAuditEvent(cfg, ["change-log"], "log records when administrator privileges are modified"),
    "JUNI-ND-001240": (cfg) => checkJunosAuditEvent(cfg, ["change-log"], "log records when administrator privileges are deleted"),
    "JUNI-ND-001250": (cfg) => checkJunosAuditEvent(cfg, ["authorization"], "logon attempt auditing"),
    "JUNI-ND-001260": (cfg) => checkJunosAuditEvent(cfg, ["change-log", "interactive-commands"], "privileged activity logging", true),
    "JUNI-ND-001280": (cfg) => checkJunosAuditEvent(cfg, ["authorization"], "concurrent-logon detection"),

    "JUNI-ND-001300": (cfg) => {
      const hosts = parseJunosSyslogHosts(cfg);
      return hosts.length > 0
        ? { match: true, confidence: "high", detail: `Log records are sent to an external syslog host: ${hosts.map(h => h.raw).join("; ")}.`, evidence: hosts.map(h => h.raw) }
        : { match: false, confidence: "high", detail: "No external syslog host ('host <addr> { ... }') found - logs aren't being off-loaded." };
    },

    "JUNI-ND-001340": (cfg) => checkJunosAuditEvent(cfg, ["authorization", "change-log"], "a locally-developed list of auditable events"),

    "JUNI-ND-001360": (cfg) => {
      function countServers(kind) {
        const headerRe = kind === "radius" ? /^\s*radius-server\s*\{/i : /^\s*tacplus-server\s*\{/i;
        const addrs = new Set();
        parseJunosBlocks(cfg, headerRe).forEach(b => {
          parseJunosBlocks(b.raw, /^\s*\S+\s*\{/i).forEach(sub => {
            const hm = sub.header.match(/^\s*(\S+)/);
            if (hm && /^\d{1,3}(\.\d{1,3}){3}$/.test(hm[1])) addrs.add(hm[1]);
          });
          allMatches(b.raw, /^\s*(\d{1,3}(?:\.\d{1,3}){3})\s+secret\b/im).forEach(m => addrs.add(m[1]));
        });
        return addrs;
      }
      const radiusAddrs = countServers("radius");
      const tacacsAddrs = countServers("tacacs");
      const orderMatch = cfg.match(/^\s*authentication-order\s+(.*);/im);
      const usesRadius = orderMatch && /radius/i.test(orderMatch[1]);
      const usesTacacs = orderMatch && /tacplus/i.test(orderMatch[1]);
      if (!orderMatch || (!usesRadius && !usesTacacs)) {
        return { match: false, confidence: "high", detail: "No 'authentication-order' referencing radius/tacplus found." };
      }
      const problems = [];
      let satisfied = false;
      if (usesRadius) {
        if (radiusAddrs.size >= 2) satisfied = true;
        else problems.push(`RADIUS is used but only ${radiusAddrs.size} unique server address(es) found (need >= 2)`);
      }
      if (usesTacacs) {
        if (tacacsAddrs.size >= 2) satisfied = true;
        else problems.push(`TACACS+ is used but only ${tacacsAddrs.size} unique server address(es) found (need >= 2)`);
      }
      if (satisfied && problems.length === 0) {
        return { match: true, confidence: "high", detail: `Authentication order (${orderMatch[1].trim()}) resolves to a method backed by >= 2 servers.`, evidence: [orderMatch[0].trim()] };
      }
      return { match: false, confidence: "high", detail: "Issue(s): " + problems.join("; ") + "." };
    },

    "JUNI-ND-001400": (cfg) => {
      return /^\s*transfer-on-commit;/im.test(cfg)
        ? { match: true, confidence: "high", detail: "'transfer-on-commit;' is configured under archival/configuration, automatically backing up the configuration on every commit." }
        : { match: false, confidence: "medium", detail: "No 'transfer-on-commit;' statement found. This is the one specific mechanism this rule's check text shows - if backups are handled a different way, verify manually." };
    },

    "JUNI-ND-001430": (cfg) => {
      const hasCaProfile = /^\s*ca-profile\s+\S+\s*\{/im.test(cfg);
      if (!hasCaProfile) {
        return { status: "not_applicable", confidence: "medium", detail: "No 'ca-profile' found under security/pki - per this rule's own logic, it doesn't apply if the router has no public key certificates. Verify no certificate-based services are actually in use." };
      }
      return { status: "manual", confidence: "medium", detail: "A CA profile is configured - a human needs to verify the CA is a DoD or DoD-approved CA, which a config file alone can't confirm.", evidence: allMatches(cfg, /^\s*ca-profile\s+\S+/im).map(m => m[0].trim()) };
    },

    "JUNI-ND-001440": (cfg) => {
      const hosts = parseJunosSyslogHosts(cfg);
      const uniqueAddrs = [...new Set(hosts.map(h => h.address))];
      if (uniqueAddrs.length >= 2) return { match: true, confidence: "high", detail: `${uniqueAddrs.length} unique syslog server(s) configured: ${uniqueAddrs.join(", ")}.`, evidence: hosts.map(h => h.raw) };
      if (uniqueAddrs.length === 1) return { match: false, confidence: "high", detail: `Only one unique syslog server configured (${uniqueAddrs[0]}); at least two are required.`, evidence: hosts.map(h => h.raw) };
      return { match: false, confidence: "high", detail: "No syslog host destination found." };
    },

    // --- RTR ---
    "JUNI-RT-000070": (cfg) => {
      const bad = [
        { re: /^\s*finger;/im, label: "finger" },
        { re: /^\s*ftp;/im, label: "ftp" },
        { re: /^\s*telnet;/im, label: "telnet" }
      ];
      const found = bad.filter(b => b.re.test(cfg)).map(b => b.label);
      return found.length === 0
        ? { match: true, confidence: "high", detail: "None of finger/ftp/telnet were found enabled under services." }
        : { match: false, confidence: "high", detail: "Unnecessary service(s) enabled: " + found.join(", ") + "." };
    },

    "JUNI-RT-000120": (cfg) => checkJunosLoopbackFilterPresence(cfg, "classifies and polices control-plane traffic (CoPP)"),
    "JUNI-RT-000130": (cfg) => checkJunosLoopbackFilterPresence(cfg, "restricts traffic destined to the router itself"),

    "JUNI-RT-000140": (cfg) => {
      const found = allMatches(cfg, /is-fragment;[\s\S]{0,80}?protocol\s+icmp;|protocol\s+icmp;[\s\S]{0,80}?is-fragment;/gim).map(m => m[0].replace(/\s+/g, " ").trim());
      return found.length === 0
        ? { match: false, confidence: "medium", detail: "No firewall term matching 'protocol icmp' + 'is-fragment' found - fragmented ICMP destined to the router doesn't appear to be dropped." }
        : { status: "manual", confidence: "low", detail: `Found term(s) matching on fragmented ICMP, but term ORDER relative to other permit-icmp terms can't be verified generically - confirm manually: ${found.join("; ")}`, evidence: found };
    },

    "JUNI-RT-000150": (cfg) => {
      const candidates = findLikelyExternalJunosInterfaces(cfg);
      if (candidates.length === 0) {
        return { status: "manual", confidence: "low", detail: "Couldn't identify any likely-external interface from description text - verify 'gratuitous-arp-reply' is not set manually on untrusted-facing interfaces." };
      }
      const bad = candidates.filter(b => /^\s*gratuitous-arp-reply;/im.test(b.raw));
      return bad.length === 0
        ? { match: true, confidence: "medium", detail: `None of the ${candidates.length} likely-external interface(s) have 'gratuitous-arp-reply' set.`, evidence: candidates.map(b => b.header) }
        : { match: false, confidence: "medium", detail: `'gratuitous-arp-reply' is set on likely-external interface(s): ${bad.map(b => b.header).join(", ")}.`, evidence: bad.map(b => b.header) };
    },

    "JUNI-RT-000190": (cfg) => {
      const candidates = findLikelyExternalJunosInterfaces(cfg);
      if (candidates.length === 0) {
        return { status: "manual", confidence: "low", detail: "Couldn't identify any likely-external interface from description text - verify 'no-redirects;' is set manually under family inet on untrusted-facing interfaces." };
      }
      const missing = candidates.filter(b => !/^\s*no-redirects;/im.test(b.raw));
      return missing.length === 0
        ? { match: true, confidence: "medium", detail: `All ${candidates.length} likely-external interface(s) have 'no-redirects;'.`, evidence: candidates.map(b => b.header) }
        : { match: false, confidence: "medium", detail: `Missing 'no-redirects;' on likely-external interface(s): ${missing.map(b => b.header).join(", ")}.`, evidence: missing.map(b => b.header) };
    },

    "JUNI-RT-000200": (cfg) => checkJunosFilterLogging(cfg),
    "JUNI-RT-000210": (cfg) => checkJunosFilterLogging(cfg),
    "JUNI-RT-000220": (cfg) => checkJunosFilterLogging(cfg),

    "JUNI-RT-000350": (cfg) => {
      const found = allMatches(cfg, /ip-options\s+any;[\s\S]{0,150}?(discard|reject|syslog)/gim).map(m => m[0].replace(/\s+/g, " ").trim());
      return found.length === 0
        ? { match: false, confidence: "medium", detail: "No firewall term found matching 'ip-options any' with a discard/reject/syslog action - IP-option packets don't appear to be blocked." }
        : { match: true, confidence: "medium", detail: `Found firewall term(s) blocking IP-option packets: ${found.join("; ")}`, evidence: found };
    }
  };

  const JUNIPER_RISKY_RULES = [
    {
      id: "JUNI-ND-001400",
      label: "Configuration Backup on Change",
      blurb: "The only mechanism this rule's check text shows is 'transfer-on-commit;' - if backups are handled a different way, a device using that would be incorrectly flagged Open."
    },
    {
      id: "JUNI-RT-000140",
      label: "Fragmented ICMP Dropped",
      blurb: "Presence of a fragment+ICMP firewall term is checked, but this rule also requires that term come before any permit-icmp term in the same filter - ordering can't be verified generically."
    },
    {
      id: "JUNI-RT-000150",
      label: "Gratuitous ARP Disabled (External Interfaces)",
      blurb: "Relies on a description-keyword heuristic to guess which interfaces are external, since Junos has no config-level flag for this - a genuinely external interface with an unmatched description is invisible to this check."
    },
    {
      id: "JUNI-RT-000190",
      label: "ICMP Redirects Disabled (External Interfaces)",
      blurb: "Same external-interface description-keyword heuristic as the Gratuitous ARP check above, with the same blind spot."
    }
  ];

  // -------------------------------------------------------------------
  // Platform detection. The Router NDM STIG reuses the switch NDM STIG's
  // exact rule_version IDs for a completely different command syntax, so
  // rule_version ALONE can't tell you which check table applies - it has
  // to be resolved per-STIG-block from the STIG's own identifying text.
  // Detected once per STIG within the loaded template (a template can
  // legitimately bundle more than one STIG, e.g. Router NDM + Router RTR
  // together, as seen in real .cklb exports), defaulting to "switch" when
  // neither signal is present, which preserves this tool's original,
  // switch-only behavior for any template lacking clear platform metadata.
  // -------------------------------------------------------------------
  function detectPlatformForStig(stig) {
    const text = [stig.stig_id, stig.stig_name, stig.display_name].filter(Boolean).join(" ").toLowerCase();
    // Juniper's own stig_id also contains "Router" (e.g.
    // "Juniper_Router_NDM_STIG"), so it must be checked BEFORE the
    // Cisco/generic "router" fallback below, or every Juniper template
    // would silently resolve to the Cisco IOS-XR check table instead.
    if (text.includes("juniper") || text.includes("junos")) return "juniper";
    if (text.includes("ios-xr") || text.includes("ios xr") || /\brouter\b/.test(text)) return "router";
    if (text.includes("ios-xe") || text.includes("ios xe") || /\bswitch\b/.test(text)) return "switch";
    return "switch";
  }

  function getRuleCheckTable(platform) {
    if (platform === "router") return ROUTER_RULE_CHECKS;
    if (platform === "juniper") return JUNIPER_RULE_CHECKS;
    return RULE_CHECKS;
  }

  function getRiskyRulesForPlatform(platform) {
    if (platform === "router") return ROUTER_RISKY_RULES;
    if (platform === "juniper") return JUNIPER_RISKY_RULES;
    return RISKY_RULES;
  }

  // Fill in the real count now that all tables are fully defined, rather
  // than hand-maintaining a number in the HTML that goes stale the moment
  // a check is added or removed.
  const subtitleEl = document.getElementById("subtitleText");
  if (subtitleEl) {
    const n = Object.keys(RULE_CHECKS).length + Object.keys(ROUTER_RULE_CHECKS).length + Object.keys(JUNIPER_RULE_CHECKS).length;
    subtitleEl.textContent = `Cisco IOS-XE Switch, IOS-XR Router, or Juniper Router NDM/RTR STIG — one template checklist, any number of device configs, matched against ${n} rule checks (auto-detected per platform) entirely in your browser. Nothing is uploaded anywhere.`;
  }

  function checkFilePrivilege(cfg) {
    const persistent = /^logging persistent url/im.test(cfg);
    if (!persistent) {
      return { status: "not_applicable", detail: "Persistent logging is not configured, so this control does not apply." };
    }
    const m = cfg.match(/^file privilege\s+(\d+)/im);
    if (!m) {
      return { match: true, detail: "Persistent logging is enabled; no 'file privilege' override found, so the secure default (15) remains in effect." };
    }
    const priv = parseInt(m[1], 10);
    return priv === 15
      ? { match: true, detail: "Persistent logging is enabled; file privilege is explicitly set to 15 (default/secure)." }
      : { match: false, detail: `Persistent logging is enabled; file privilege is set to ${priv} (weaker than the required 15).` };
  }

  // -------------------------------------------------------------------
  // Shared by 8 separate DISA rules (account creation/modification/
  // disabling/removal/enabling audit, full-text privileged-command
  // logging, and log records for privileged activity / deleted admin
  // privileges) that all use the EXACT same check text and configuration
  // example verbatim:
  //   archive
  //    log config
  //     logging enable
  // Each rule differs only in WHICH administrative action it's auditing,
  // not in what config actually satisfies it - so one parser serves all
  // eight, with activityLabel only changing the wording of the result.
  // -------------------------------------------------------------------
  function auditArchiveLogConfigEnabled(cfg, activityLabel) {
    const blocks = parseConfigBlocks(cfg, /^archive\s*$/i);
    if (blocks.length === 0) {
      return { match: false, confidence: "high", detail: `No 'archive' block found in configuration - ${activityLabel} is not being automatically audited.` };
    }
    for (const b of blocks) {
      const body = b.lines.join("\n");
      if (/^\s*log config\b/im.test(body) && /^\s*logging enable\b/im.test(body)) {
        return {
          match: true, confidence: "high",
          detail: `'archive' block includes 'log config' with 'logging enable' - ${activityLabel} is automatically audited via the archive log config mechanism.`,
          evidence: ["archive", " log config", "  logging enable"]
        };
      }
    }
    return { match: false, confidence: "high", detail: `An 'archive' block exists, but it doesn't include both 'log config' and 'logging enable' - ${activityLabel} is not being automatically audited.` };
  }

  // Generic common-criteria policy check driven entirely by CC_REQUIREMENTS -
  // a STIG revision to one of these thresholds is now a one-line data edit
  // instead of a hunt through six near-identical function bodies.
  function ccCheckByRule(cc, ruleId) {
    const req = CC_REQUIREMENTS[ruleId];
    if (!req) throw new Error(`No CC_REQUIREMENTS entry defined for ${ruleId}`);
    if (!cc) return { match: false, confidence: "high", detail: "No 'aaa common-criteria policy' block found in configuration." };
    const m = cc.match(new RegExp("^\\s*" + escapeRegex(req.key) + "\\s+(\\d+)", "im"));
    if (m) {
      const val = parseInt(m[1], 10);
      return val >= req.min
        ? { match: true, confidence: "high", detail: `Common-criteria policy ${req.key} is ${val} (>= ${req.min} required).`, evidence: [`${req.key} ${val}`] }
        : { match: false, confidence: "high", detail: `Common-criteria policy ${req.key} is ${val} (< ${req.min} required).`, evidence: [`${req.key} ${val}`] };
    }
    return { match: false, confidence: "high", detail: `No '${req.key}' setting (>= ${req.min}) found in the common-criteria policy block.` };
  }

  // -------------------------------------------------------------------
  // Run — process every config against a fresh copy of the template
  // -------------------------------------------------------------------
  document.getElementById("runBtn").addEventListener("click", () => {
    // Defensive re-check: the template was validated on load, but guard
    // here too in case it was mutated in ways validation wouldn't catch.
    const structureError = validateCklbStructure(cklbTemplateData);
    if (structureError) {
      alert("Cannot run - invalid CKLB structure: " + structureError);
      return;
    }

    const deviceResults = [];
    let grandNA = 0, grandOpen = 0, grandFilled = 0, grandErrors = 0;
    let grandManualVerdict = 0, grandNotAutomated = 0;
    const disabledRiskyKeys = getDisabledRiskyKeys();
    const runTimestamp = new Date().toISOString().slice(0, 16).replace("T", " ");
    const includePossibleMatches = document.getElementById("possibleMatchesToggle").checked;

    // Manual-review evidence anchors depend only on the template and which
    // risky checks are disabled this run, so build this list once and
    // reuse it for every device.
    const parsedTemplate = JSON.parse(cklbTemplateText);
    const manualRules = buildManualRuleList(parsedTemplate, disabledRiskyKeys);

    // Dynamic, computed-from-the-actual-template counts for the transparency
    // banner - never hardcode "35 rules" or "26 automated" in text, since
    // that goes stale the moment a check is added or a different STIG's
    // cklb is loaded.
    let totalRuleCount = 0, hasCheckCount = 0;
    const templateRuleIds = new Set();
    (parsedTemplate.stigs || []).forEach(stig => {
      const table = getRuleCheckTable(detectPlatformForStig(stig));
      (stig.rules || []).forEach(rule => {
        totalRuleCount++;
        templateRuleIds.add(rule.rule_version);
        if (table[rule.rule_version]) hasCheckCount++;
      });
    });
    // Only count a "disabled via toggle" rule if it's actually present in
    // THIS template - otherwise loading a CKLB that doesn't contain all of
    // the risky-panel rule IDs could produce a disabledByToggle count (and
    // therefore an "enabled this run" count) that doesn't match reality.
    const applicableDisabledRisky = new Set(
      [...disabledRiskyKeys].filter(id => templateRuleIds.has(id))
    );
    const ruleCounts = {
      total: totalRuleCount,
      withCheck: hasCheckCount,
      disabledByToggle: applicableDisabledRisky.size,
      neverAutomated: totalRuleCount - hasCheckCount
    };

    const usedOutputNames = new Map(); // base filename -> count seen so far, for collision-safe naming
    const deviceLoadErrors = []; // devices that failed entirely, outside any individual rule check

    configFiles.forEach(cf => {
      try {
        processOneDevice(cf);
      } catch (err) {
        // A single malformed/unexpected config must never abort the whole
        // batch - isolate the failure to this one device, surface it
        // clearly, and keep processing the rest. Without this, one bad
        // file out of 50 could silently cost you every other device's
        // results too.
        deviceLoadErrors.push({ name: cf.name, message: err.message });
        deviceResults.push({
          deviceName: cf.name,
          outputName: null,
          loadError: err.message,
          filled: 0, na: 0, open: 0, naOther: 0, errorCount: 0,
          manualVerdictCount: 0, notAutomatedCount: 0, manualTotal: 0,
          rows: [], manualEvidence: [],
          cklbJson: null
        });
      }
    });

    function processOneDevice(cf) {
      const configText = cf.text;
      const ccBlock = getCcPolicyBlock(configText);
      const fallbackName = cf.name.replace(/\.[^.]+$/, "");
      const detectedHostname = getDeviceName(configText, null);
      const deviceName = detectedHostname || fallbackName;

      // Fresh deep copy of the template for every device
      const cklb = JSON.parse(cklbTemplateText);
      // Split once and reuse for the evidence grepper below - avoids
      // re-splitting the whole config on every anchor of every manual rule.
      const configLines = configText.split("\n");

      let filled = 0, na = 0, open = 0, naOther = 0, errorCount = 0;
      const rows = [];

      (cklb.stigs || []).forEach(stig => {
        const platformTable = getRuleCheckTable(detectPlatformForStig(stig));
        (stig.rules || []).forEach(rule => {
          const key = rule.rule_version;
          // A rule with a check entry that's been unchecked in the
          // "uncertain checks" panel is treated as if it had no automated
          // check at all this run - it falls through to the manual-evidence
          // pass below instead. platformTable is resolved per-STIG-block
          // (see detectPlatformForStig), never globally per template, so a
          // template bundling e.g. Router NDM + Router RTR together still
          // resolves each block correctly.
          const check = disabledRiskyKeys.has(key) ? null : platformTable[key];
          if (!check) return;

          const meta = { title: rule.rule_title, discussion: rule.discussion, checkContent: rule.check_content, fixText: rule.fix_text };
          let norm;
          try {
            const raw = check(configText, ccBlock, rule);
            if (raw == null) return; // this checker deliberately declined to adjudicate this run
            norm = normalizeCheckResult(raw);
          } catch (err) {
            // A crashing OR malformed-result check must never fail silently
            // in a compliance tool - that's a rule nobody knows wasn't
            // actually evaluated. Surface it as a visible manual-review
            // item with the error message attached, both in the UI and in
            // the exported file.
            errorCount++;
            rule.finding_details = "AUTOMATION ERROR - MANUAL REVIEW REQUIRED: " + err.message;
            rows.push({ vid: rule.group_id, status: "error", detail: "Check threw an error: " + err.message, ...meta });
            return;
          }

          if (norm.statusKind === "manual") {
            // Found something but can't confirm it's actually correct
            // (banner text, documented account, etc) - leave the template's
            // not_reviewed status untouched, just attach the evidence found.
            const confPrefix = norm.confidence ? `[Confidence: ${norm.confidence.toUpperCase()}] ` : "";
            rule.finding_details = confPrefix + "AUTOMATED CHECK RAN - FLAGGED FOR MANUAL REVIEW (not an adjudication): " + norm.detail +
              (norm.evidence.length ? " | Evidence: " + norm.evidence.join(" | ") : "");
            rows.push({ vid: rule.group_id, status: "manual", detail: norm.detail, confidence: norm.confidence, ...meta });
            return;
          }

          // pass -> not_a_finding, fail -> open, not_applicable -> passed
          // through as-is ("applies but fails" isn't the right frame there).
          rule.status = norm.statusKind === "not_applicable" ? "not_applicable"
            : (norm.statusKind === "pass" ? "not_a_finding" : "open");
          const confPrefix = norm.confidence ? `[Confidence: ${norm.confidence.toUpperCase()}] ` : "";
          rule.finding_details = confPrefix + norm.detail;
          rule.comments = `Auto-filled by CKLB Auto-Fill v${TOOL_VERSION} on ${runTimestamp} UTC | Source config: ${cf.name} | Detected hostname: ${detectedHostname || "(none found - used config filename)"} - verify before submitting.`;

          filled++;
          if (rule.status === "not_a_finding") na++;
          else if (rule.status === "open") open++;
          else naOther++;
          rows.push({ vid: rule.group_id, status: rule.status, detail: norm.detail, confidence: norm.confidence, ...meta });
        });
      });

      // Fresh checklist ID per device - avoids collisions with the
      // template and with every other device's exported file.
      if ("id" in cklb) {
        cklb.id = (crypto.randomUUID ? crypto.randomUUID() : fallbackUuid());
      }

      // Persist evidence into COMMENTS (not finding_details) for every
      // not-automated rule where something was actually found - so a
      // reviewer opening this file later, without this tool open, still
      // sees it. finding_details is reserved for actual adjudications
      // this tool made; a "possible match" is not one - it's an anchor
      // hint about where to look, not proof the requirement is met, so it
      // belongs in comments/context rather than looking like a finding.
      // Status is deliberately left untouched (stays not_reviewed).
      // Skipped entirely when the "possible matches" toggle is off, but
      // manualRules.length (not manualEvidence.length) still drives the
      // Not Automated count below, so that count stays accurate either way.
      const manualEvidence = includePossibleMatches ? gatherEvidenceForDevice(manualRules, configLines, 6) : [];
      const evidenceByVid = new Map(manualEvidence.filter(m => m.lines.length > 0).map(m => [m.vid, m]));
      (cklb.stigs || []).forEach(stig => {
        (stig.rules || []).forEach(rule => {
          const ev = evidenceByVid.get(rule.group_id);
          if (!ev) return;
          const note = "POSSIBLE MATCHING CONFIGURATION LINES - INFORMATIONAL ONLY (not an adjudication - requires manual review): " + ev.lines.join(" | ");
          rule.comments = rule.comments ? rule.comments + " | " + note : note;
        });
      });

      // Distinguish "the tool evaluated this and a human needs to confirm
      // it" (Manual Review) from "this rule never had an automated check
      // run against it at all this run" (Not Automated) - they mean very
      // different things to a reviewer scanning results across many devices.
      // Uses manualRules.length rather than manualEvidence.length so this
      // count stays correct even when possible-matches searching is
      // toggled off (manualEvidence would otherwise be empty).
      const manualVerdictCount = rows.filter(r => r.status === "manual").length;
      const notAutomatedCount = manualRules.length;
      const manualTotal = manualVerdictCount + errorCount + notAutomatedCount;

      grandFilled += filled;
      grandNA += na;
      grandOpen += open;
      grandErrors += errorCount;
      grandManualVerdict += manualVerdictCount;
      grandNotAutomated += notAutomatedCount;

      // Collision-safe, sanitized output filename - two devices whose
      // hostname (or fallback filename) sanitizes to the same string no
      // longer silently overwrite each other inside the zip.
      const sanitized = sanitizeFilename(deviceName);
      const baseName = sanitized + "_filled.cklb";
      let outputName = baseName;
      if (usedOutputNames.has(baseName)) {
        const n = usedOutputNames.get(baseName) + 1;
        usedOutputNames.set(baseName, n);
        outputName = `${sanitized}_${n}_filled.cklb`;
      } else {
        usedOutputNames.set(baseName, 1);
      }

      // Keep the CKLB's own "title" field in sync with the exported
      // filename (hostname + "_filled") - previously it stayed whatever
      // the template's title happened to be, so opening the file later
      // (in this tool or elsewhere) showed a title that didn't match which
      // device it actually came from. Uses the FINAL, de-dup-safe
      // outputName so title and filename can never drift apart even when
      // two devices' sanitized names collided.
      cklb.title = outputName.replace(/\.cklb$/i, "");

      deviceResults.push({
        deviceName,
        outputName,
        filled, na, open, naOther, errorCount,
        manualVerdictCount, notAutomatedCount, manualTotal,
        rows,
        manualEvidence,
        cklbJson: JSON.stringify(cklb, null, 2)
      });
    }

    if (deviceLoadErrors.length > 0) {
      alert(`${deviceLoadErrors.length} device(s) failed to process and were skipped: ${deviceLoadErrors.map(e => e.name).join(", ")}. The rest of the batch still completed - see the results below for details on each failure.`);
    }

    renderResults(deviceResults, grandFilled, grandNA, grandOpen, grandErrors, grandManualVerdict, grandNotAutomated, ruleCounts);
    prepareDownload(deviceResults);
  });

  function fallbackUuid() {
    return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, c => {
      const r = (Math.random() * 16) | 0;
      const v = c === "x" ? r : (r & 0x3) | 0x8;
      return v.toString(16);
    });
  }

  let expandCounter = 0;

  function buildMetaHtml(meta) {
    if (!meta) return "<em>No additional details available.</em>";
    const parts = [];
    if (meta.title) parts.push(`<dt>Rule title</dt><dd>${escapeHtml(meta.title)}</dd>`);
    if (meta.discussion) parts.push(`<dt>Discussion</dt><dd>${escapeHtml(meta.discussion)}</dd>`);
    if (meta.checkContent) parts.push(`<dt>Check text</dt><dd>${escapeHtml(meta.checkContent)}</dd>`);
    if (meta.fixText) parts.push(`<dt>Fix text</dt><dd>${escapeHtml(meta.fixText)}</dd>`);
    return parts.length ? `<dl>${parts.join("")}</dl>` : "<em>No additional details available.</em>";
  }

  function addExpandableRow(tbody, vidLabel, restCellsHtml, meta, colSpan) {
    const id = "detail-" + (expandCounter++);

    const tr = document.createElement("tr");
    tr.innerHTML = `<td class="vid"><span class="vid-toggle">${CHEVRON_SVG}${escapeHtml(vidLabel)}</span></td>` + restCellsHtml;
    tbody.appendChild(tr);

    const detailTr = document.createElement("tr");
    detailTr.className = "detail-row hidden";
    const td = document.createElement("td");
    td.colSpan = colSpan || 3;
    td.innerHTML = buildMetaHtml(meta);
    detailTr.appendChild(td);
    tbody.appendChild(detailTr);

    const toggle = tr.querySelector(".vid-toggle");
    toggle.addEventListener("click", () => {
      detailTr.classList.toggle("hidden");
      toggle.classList.toggle("expanded");
    });

    return { tr, detailTr };
  }

  function renderResults(deviceResults, grandFilled, grandNA, grandOpen, grandErrors, grandManualVerdict, grandNotAutomated, ruleCounts) {
    document.getElementById("results").classList.remove("hidden");
    document.getElementById("statDevices").textContent = deviceResults.length;
    document.getElementById("statFilled").textContent = grandFilled;
    document.getElementById("statNA").textContent = grandNA;
    document.getElementById("statOpen").textContent = grandOpen;
    document.getElementById("statManual").textContent = grandManualVerdict;
    document.getElementById("statNotAutomated").textContent = grandNotAutomated;
    const errWrap = document.getElementById("statErrorWrap");
    if (grandErrors > 0) {
      errWrap.classList.remove("hidden");
      document.getElementById("statErrors").textContent = grandErrors;
    } else {
      errWrap.classList.add("hidden");
    }

    // A prominent, non-blocking warning when any check crashed outright -
    // these are the one category that genuinely means "something wasn't
    // evaluated the way it should have been," distinct from ordinary
    // manual-review items, so it gets called out above everything else.
    const errorBanner = document.getElementById("errorBanner");
    if (grandErrors > 0) {
      errorBanner.classList.remove("hidden");
      errorBanner.textContent = `⚠ ${grandErrors} AUTOMATION ERROR${grandErrors === 1 ? "" : "S"} — MANUAL REVIEW REQUIRED before submitting any affected checklist.`;
    } else {
      errorBanner.classList.add("hidden");
    }

    // Never let it be ambiguous how many rules in the template got no
    // automated attention at all, computed live from the actual loaded
    // cklb and current toggle state rather than a hardcoded number that
    // goes stale the moment a check is added or a different STIG is loaded.
    const banner = document.getElementById("rulesBanner");
    banner.innerHTML = `<strong>${ruleCounts.total}</strong> total rules per device &middot; ` +
      `<strong>${ruleCounts.withCheck - ruleCounts.disabledByToggle}</strong> have an automated check enabled this run &middot; ` +
      (ruleCounts.disabledByToggle > 0 ? `<strong>${ruleCounts.disabledByToggle}</strong> disabled via "Uncertain checks" &middot; ` : "") +
      `<strong>${ruleCounts.neverAutomated}</strong> have no automated check at all &middot; ` +
      `<strong>0</strong> silently skipped - every rule either gets adjudicated, a manual-review verdict, or explicit evidence.`;

    const container = document.getElementById("deviceTables");
    container.innerHTML = "";

    const STATUS_LABELS = {
      not_a_finding: { cls: "na", label: "Not a Finding" },
      open: { cls: "open", label: "Open" },
      not_applicable: { cls: "manual", label: "Not Applicable" },
      manual: { cls: "manual", label: "Manual Review" },
      error: { cls: "error", label: "Automation Error" }
    };

    deviceResults.forEach(dev => {
      const block = document.createElement("div");
      block.className = "device-block";
      // Dataset used by the sort control below - read fresh from these
      // rather than recomputing, so sorting never has to re-touch the
      // underlying result data.
      block.dataset.deviceName = dev.deviceName;
      block.dataset.open = dev.open;
      block.dataset.manual = dev.manualVerdictCount;
      block.dataset.notAutomated = dev.notAutomatedCount;
      block.dataset.errors = dev.errorCount;

      if (dev.loadError) {
        // This device never got past initial processing (bad encoding,
        // unexpected exception, etc) - a distinct, unmistakable card
        // instead of empty tables, and exempted from the status filter's
        // "hide devices with zero matching rows" behavior below, since it
        // has no rows to match in the first place but is exactly the kind
        // of thing you don't want silently filtered out of view.
        block.dataset.loadError = "1";
        block.innerHTML = `<div class="device-head" style="cursor:default;"><h3 style="padding-left:1.4em;">${escapeHtml(dev.deviceName)}</h3><span class="counts status error">FAILED TO PROCESS</span></div>` +
          `<div class="load-error-detail">This device could not be processed and was skipped - the rest of the batch still completed. Error: ${escapeHtml(dev.loadError)}</div>`;
        container.appendChild(block);
        return;
      }

      // Main findings table is now collapsible - click the device header to
      // show/hide it, same interaction pattern as the "Uncertain checks"
      // panel above. Defaults to expanded so nothing changes for anyone
      // who never touches the chevron.
      const head = document.createElement("div");
      head.className = "device-head expanded";
      const headParts = [`${dev.na} not a finding`, `${dev.open} open`, `${dev.manualVerdictCount} manual review`, `${dev.notAutomatedCount} not automated`];
      if (dev.naOther) headParts.push(`${dev.naOther} not applicable`);
      if (dev.errorCount) headParts.push(`${dev.errorCount} automation error${dev.errorCount === 1 ? "" : "s"}`);
      head.innerHTML = `<h3>${CHEVRON_SVG}${escapeHtml(dev.deviceName)}</h3><span class="counts">${headParts.join(" · ")}</span>`;
      block.appendChild(head);

      const tableWrap = document.createElement("div");
      const table = document.createElement("table");
      const tbody = document.createElement("tbody");
      table.innerHTML = `<thead><tr><th>V-ID (click to expand)</th><th>Status</th><th>Confidence</th><th>Detail</th></tr></thead>`;
      table.appendChild(tbody);
      dev.rows.forEach(r => {
        const s = STATUS_LABELS[r.status] || { cls: "manual", label: r.status };
        const conf = r.confidence || "-";
        const statusHtml = `<td class="status ${s.cls}">${s.label}</td>`;
        const confHtml = `<td class="confidence ${conf}">${conf === "-" ? "-" : conf}</td>`;
        const detailHtml = `<td class="detail">${escapeHtml(r.detail)}</td>`;
        const { tr } = addExpandableRow(tbody, r.vid, statusHtml + confHtml + detailHtml, r, 4);
        // Tagged for the status filter below - only main-findings rows have
        // a real adjudication status, so only these are ever hidden by it.
        tr.dataset.status = r.status;
      });
      tableWrap.appendChild(table);
      block.appendChild(tableWrap);
      head.addEventListener("click", () => {
        tableWrap.classList.toggle("hidden");
        head.classList.toggle("expanded");
      });

      const withEvidence = dev.manualEvidence.filter(m => m.lines.length > 0);
      const withoutEvidence = dev.manualEvidence.filter(m => m.lines.length === 0);
      // gatherEvidenceForDevice always returns one entry per not-automated
      // rule (with lines:[] when nothing matched), so the only way
      // manualEvidence ends up empty while notAutomatedCount is nonzero is
      // that the search was skipped entirely (toggle off) - no separate
      // flag needs to be threaded through just to know that.
      const possibleMatchesWereSearched = dev.manualEvidence.length > 0 || dev.notAutomatedCount === 0;

      if (withEvidence.length > 0) {
        // Same collapsible pattern as the main findings table, but this one
        // defaults COLLAPSED, not expanded: these are, by definition,
        // incomplete checks (no automated adjudication ran at all - the
        // main table already covers everything that actually got a
        // determination). Keeping this closed by default means opening a
        // batch of results leads with what's actually decided, not with
        // a pile of "maybe relevant" anchors competing for attention.
        const sub = document.createElement("div");
        sub.className = "subhead section-toggle";
        sub.innerHTML = `${CHEVRON_SVG}Not automated — possible matching config lines (informational only) (${withEvidence.length} of ${dev.manualEvidence.length} rules have matching lines)`;
        block.appendChild(sub);

        const matchWrap = document.createElement("div");
        matchWrap.classList.add("hidden");
        const mTable = document.createElement("table");
        const mBody = document.createElement("tbody");
        mTable.innerHTML = `<thead><tr><th>V-ID (click to expand)</th><th>Rule</th><th>Possible matching config lines (informational)</th></tr></thead>`;
        mTable.appendChild(mBody);
        withEvidence.forEach(m => {
          const lines = m.lines.map(l => `<div>${escapeHtml(l)}</div>`).join("");
          const titleLabel = m.title + (m.disabledByToggle ? " (check disabled)" : "");
          const titleHtml = `<td class="detail">${escapeHtml(titleLabel)}</td>`;
          const evidenceHtml = `<td class="evidence">${lines}</td>`;
          addExpandableRow(mBody, m.vid, titleHtml + evidenceHtml, m);
        });
        matchWrap.appendChild(mTable);
        block.appendChild(matchWrap);
        sub.addEventListener("click", () => {
          matchWrap.classList.toggle("hidden");
          sub.classList.toggle("expanded");
        });
      } else if (dev.notAutomatedCount > 0 && !possibleMatchesWereSearched) {
        // The toggle above the Run button was off this run, so no config
        // search happened at all for not-automated rules - make that
        // explicit rather than leaving an unexplained gap where the
        // possible-matches section would normally be.
        const note = document.createElement("div");
        note.className = "section-note";
        note.textContent = `Possible-matches evidence search was off for this run (${dev.notAutomatedCount} not-automated rule(s) on this device weren't searched). Enable the toggle above "Run checks" and re-run to include it.`;
        block.appendChild(note);
      }

      if (possibleMatchesWereSearched && withoutEvidence.length > 0) {
        // Same collapsible pattern (and same custom SVG chevron) as every
        // other section, rather than a native <details>/<summary> - that
        // element brings the browser's own tiny built-in disclosure
        // triangle, which renders visibly smaller/different than our SVG
        // chevron used everywhere else, an inconsistency worth avoiding.
        // Defaults collapsed for the same reason as the possible-matches
        // section above: this is explicitly a "nothing found" list, lower
        // priority than an actual determination.
        const noEvSub = document.createElement("div");
        noEvSub.className = "subhead section-toggle";
        noEvSub.innerHTML = `${CHEVRON_SVG}Not automated — no matching configuration evidence found (${withoutEvidence.length})`;
        block.appendChild(noEvSub);

        const noEvWrap = document.createElement("div");
        noEvWrap.classList.add("hidden");
        const list = document.createElement("ul");
        list.className = "no-evidence-list";
        withoutEvidence.forEach(m => {
          const li = document.createElement("li");
          li.textContent = `${m.vid} — ${m.title}${m.disabledByToggle ? " (check disabled)" : ""}`;
          list.appendChild(li);
        });
        noEvWrap.appendChild(list);
        block.appendChild(noEvWrap);
        noEvSub.addEventListener("click", () => {
          noEvWrap.classList.toggle("hidden");
          noEvSub.classList.toggle("expanded");
        });
      }

      container.appendChild(block);
    });

    document.getElementById("resultsToolbar").classList.remove("hidden");
    applyResultsView();
  }

  // -------------------------------------------------------------------
  // Filter/sort is pure DOM manipulation over the already-rendered device
  // blocks - no re-fetch or recompute needed, since every value it acts on
  // (row status, per-device counts) was stamped onto the DOM as a dataset
  // attribute at render time. Re-run on every control change, and once
  // right after a fresh render so a filter/sort choice persists across runs.
  // -------------------------------------------------------------------
  function applyResultsView() {
    const statusFilter = document.getElementById("statusFilter");
    const deviceSort = document.getElementById("deviceSort");
    const container = document.getElementById("deviceTables");
    const note = document.getElementById("filterNote");
    if (!statusFilter || !container) return;

    const filterValue = statusFilter.value;
    const blocks = Array.from(container.querySelectorAll(".device-block"));

    let totalRows = 0, shownRows = 0;
    blocks.forEach(block => {
      const rows = block.querySelectorAll("table tbody tr[data-status]");
      let shownInBlock = 0;
      rows.forEach(tr => {
        totalRows++;
        const show = filterValue === "all" || tr.dataset.status === filterValue;
        if (show) {
          tr.classList.remove("hidden");
          shownRows++;
          shownInBlock++;
        } else {
          tr.classList.add("hidden");
          // Force-collapse the detail row too, so a previously-expanded
          // row doesn't leave an orphaned detail block visible under a
          // hidden main row.
          const detailTr = tr.nextElementSibling;
          if (detailTr && detailTr.classList.contains("detail-row")) {
            detailTr.classList.add("hidden");
          }
          const toggle = tr.querySelector(".vid-toggle");
          if (toggle) toggle.classList.remove("expanded");
        }
      });
      // Hide the whole device block when a filter is active and NONE of
      // its rows match - keeps a large batch scannable instead of showing
      // dozens of near-empty tables. A load-error device never has any
      // data-status rows at all, but that's a reason to keep it visible,
      // not hide it - exempt it from this rule.
      const isLoadError = block.dataset.loadError === "1";
      block.classList.toggle("filtered-empty", !isLoadError && filterValue !== "all" && shownInBlock === 0);
    });

    // Device-level sort - re-append in the new order (appendChild moves
    // existing nodes rather than cloning, so click handlers/state on them
    // survive the reorder).
    const sortValue = deviceSort ? deviceSort.value : "name";
    const sorted = blocks.slice().sort((a, b) => {
      switch (sortValue) {
        case "open_desc": return (+b.dataset.open) - (+a.dataset.open);
        case "manual_desc": return (+b.dataset.manual) - (+a.dataset.manual);
        case "notautomated_desc": return (+b.dataset.notAutomated) - (+a.dataset.notAutomated);
        case "errors_desc": return (+b.dataset.errors) - (+a.dataset.errors);
        case "name":
        default: return a.dataset.deviceName.localeCompare(b.dataset.deviceName);
      }
    });
    sorted.forEach(b => container.appendChild(b));

    if (note) {
      note.textContent = filterValue !== "all"
        ? `Showing ${shownRows} of ${totalRows} finding row(s) across all devices.`
        : "";
    }
  }

  document.getElementById("statusFilter").addEventListener("change", applyResultsView);
  document.getElementById("deviceSort").addEventListener("change", applyResultsView);

  // -------------------------------------------------------------------
  // Expand all / Collapse all - operates on every collapsible section
  // currently in the DOM (device-head + its findings table, and each
  // possible-matches subhead + its table). Load-error cards are skipped -
  // they aren't collapsible sections, they're a fixed-visibility error
  // notice, so toggling them would just make the error message disappear.
  // -------------------------------------------------------------------
  function setAllSectionsExpanded(expand) {
    const container = document.getElementById("deviceTables");
    container.querySelectorAll(".device-head").forEach(head => {
      if (head.style.cursor === "default") return; // load-error card, not collapsible
      const wrap = head.nextElementSibling;
      if (!wrap) return;
      head.classList.toggle("expanded", expand);
      wrap.classList.toggle("hidden", !expand);
    });
    container.querySelectorAll(".subhead.section-toggle").forEach(sub => {
      const wrap = sub.nextElementSibling;
      if (!wrap) return;
      sub.classList.toggle("expanded", expand);
      wrap.classList.toggle("hidden", !expand);
    });
  }
  document.getElementById("expandAllBtn").addEventListener("click", () => setAllSectionsExpanded(true));
  document.getElementById("collapseAllBtn").addEventListener("click", () => setAllSectionsExpanded(false));

  function escapeHtml(s) {
    const d = document.createElement("div");
    d.textContent = s;
    return d.innerHTML;
  }

  // -------------------------------------------------------------------
  // Minimal ZIP writer (store/no-compression) — no external library, so
  // this stays fully offline-capable. Produces a standard PK zip that
  // Windows Explorer / 7-Zip / unzip all read fine.
  // -------------------------------------------------------------------
  const CRC_TABLE = (() => {
    const table = [];
    for (let n = 0; n < 256; n++) {
      let c = n;
      for (let k = 0; k < 8; k++) c = (c & 1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1);
      table[n] = c >>> 0;
    }
    return table;
  })();

  function crc32(bytes) {
    let crc = 0xFFFFFFFF;
    for (let i = 0; i < bytes.length; i++) crc = CRC_TABLE[(crc ^ bytes[i]) & 0xFF] ^ (crc >>> 8);
    return (crc ^ 0xFFFFFFFF) >>> 0;
  }

  function writeU32(arr, off, val) { arr[off]=val&255; arr[off+1]=(val>>>8)&255; arr[off+2]=(val>>>16)&255; arr[off+3]=(val>>>24)&255; }
  function writeU16(arr, off, val) { arr[off]=val&255; arr[off+1]=(val>>>8)&255; }

  function makeZip(files) {
    // files: [{name: string, data: Uint8Array}]
    const now = new Date();
    const time = ((now.getHours() & 31) << 11) | ((now.getMinutes() & 63) << 5) | ((now.getSeconds() >> 1) & 31);
    const dosDate = (((now.getFullYear() - 1980) & 127) << 9) | (((now.getMonth() + 1) & 15) << 5) | (now.getDate() & 31);

    const localParts = [];
    const centralParts = [];
    let offset = 0;

    files.forEach(f => {
      const nameBytes = new TextEncoder().encode(f.name);
      const data = f.data;
      const crc = crc32(data);
      const size = data.length;

      const local = new Uint8Array(30 + nameBytes.length);
      writeU32(local, 0, 0x04034b50);
      writeU16(local, 4, 20);
      writeU16(local, 6, 0);
      writeU16(local, 8, 0);
      writeU16(local, 10, time);
      writeU16(local, 12, dosDate);
      writeU32(local, 14, crc);
      writeU32(local, 18, size);
      writeU32(local, 22, size);
      writeU16(local, 26, nameBytes.length);
      writeU16(local, 28, 0);
      local.set(nameBytes, 30);
      localParts.push(local, data);

      const central = new Uint8Array(46 + nameBytes.length);
      writeU32(central, 0, 0x02014b50);
      writeU16(central, 4, 20);
      writeU16(central, 6, 20);
      writeU16(central, 8, 0);
      writeU16(central, 10, 0);
      writeU16(central, 12, time);
      writeU16(central, 14, dosDate);
      writeU32(central, 16, crc);
      writeU32(central, 20, size);
      writeU32(central, 24, size);
      writeU16(central, 28, nameBytes.length);
      writeU32(central, 42, offset);
      central.set(nameBytes, 46);
      centralParts.push(central);

      offset += local.length + data.length;
    });

    const centralSize = centralParts.reduce((a, b) => a + b.length, 0);
    const centralOffset = offset;
    const eocd = new Uint8Array(22);
    writeU32(eocd, 0, 0x06054b50);
    writeU16(eocd, 8, files.length);
    writeU16(eocd, 10, files.length);
    writeU32(eocd, 12, centralSize);
    writeU32(eocd, 16, centralOffset);

    const allParts = [...localParts, ...centralParts, eocd];
    const total = allParts.reduce((a, b) => a + b.length, 0);
    const out = new Uint8Array(total);
    let pos = 0;
    allParts.forEach(p => { out.set(p, pos); pos += p.length; });
    return out;
  }

  function prepareDownload(deviceResults) {
    const link = document.getElementById("downloadLink");
    // Devices that failed entirely (see deviceLoadErrors) have no cklbJson
    // to write - they were surfaced as an error card in the results
    // instead, and shouldn't produce a phantom/empty file in the download.
    const downloadable = deviceResults.filter(d => d.cklbJson);

    if (downloadable.length === 0) {
      link.classList.add("hidden");
      return;
    }
    if (downloadable.length === 1) {
      // Single device - just download the .cklb directly, no zip needed.
      const blob = new Blob([downloadable[0].cklbJson], { type: "application/json" });
      link.href = URL.createObjectURL(blob);
      link.download = downloadable[0].outputName;
      link.textContent = "Download " + downloadable[0].outputName;
    } else {
      const zipFiles = downloadable.map(d => ({
        name: d.outputName,
        data: new TextEncoder().encode(d.cklbJson)
      }));
      const zipBytes = makeZip(zipFiles);
      const blob = new Blob([zipBytes], { type: "application/zip" });
      link.href = URL.createObjectURL(blob);
      link.download = "filled_cklbs.zip";
      link.textContent = `Download ${downloadable.length} filled .cklb file${downloadable.length === 1 ? "" : "s"} (.zip)`;
    }
    link.classList.remove("hidden");
  }

  // -------------------------------------------------------------------
  // Embedded regression suite. Every case here is a real bug found and
  // fixed during this tool's development - each config snippet is the
  // minimal input that used to produce a wrong verdict before its fix.
  // This is a floor, not a ceiling: it only catches regressions of issues
  // already found, not new ones. When a future bug gets fixed, add its
  // case here so it can never silently come back.
  // -------------------------------------------------------------------
  const TEST_CASES = [
    { name: "000010: split vty ranges, both restricted", ruleId: "CISC-ND-000010",
      config: "line vty 0 4\n transport input none\n!\nline vty 5 15\n transport input none\n!\n",
      expectStatusKind: "pass" },
    { name: "000010: bare session-limit with no configured ceiling defers to manual", ruleId: "CISC-ND-000010",
      config: "line vty 0 4\n session-limit 2\n!\nline vty 5 15\n transport input none\n!\n",
      expectStatusKind: "manual" },
    { name: "000010: no restriction on either vty block", ruleId: "CISC-ND-000010",
      config: "line vty 0 4\n transport input ssh\n!\n",
      expectStatusKind: "fail" },

    { name: "000160: banner text extracted past a ^ delimiter", ruleId: "CISC-ND-000160",
      config: "banner login ^\nUnauthorized access prohibited.\n^\n",
      expectStatusKind: "manual", expectEvidenceContains: "Unauthorized access prohibited" },
    { name: "000160: no banner at all", ruleId: "CISC-ND-000160",
      config: "hostname X\n",
      expectStatusKind: "fail" },

    { name: "000470: explicitly disabled services aren't flagged", ruleId: "CISC-ND-000470",
      config: "no ip http server\nno ip http secure-server\n",
      expectStatusKind: "pass" },

    { name: "000490: more than one account defers to manual, not auto-Open", ruleId: "CISC-ND-000490",
      config: "username admin secret 5 aaa\nusername backup secret 5 bbb\n",
      expectStatusKind: "manual" },

    { name: "000550: min-length 15 passes", ruleId: "CISC-ND-000550",
      config: "aaa common-criteria policy PW\n min-length 15\n!\n",
      expectStatusKind: "pass" },
    { name: "000550: min-length 8 fails", ruleId: "CISC-ND-000550",
      config: "aaa common-criteria policy PW\n min-length 8\n!\n",
      expectStatusKind: "fail" },

    { name: "000620: Type 5 hash is compliant per this rule's own check text", ruleId: "CISC-ND-000620",
      config: "service password-encryption\nenable secret 5 xxxxxxxx\n",
      expectStatusKind: "pass" },
    { name: "000620: no service password-encryption fails", ruleId: "CISC-ND-000620",
      config: "enable secret 5 xxxxxxxx\n",
      expectStatusKind: "fail" },

    { name: "000720 (V-220544): exec-timeout ok + HTTP explicitly disabled", ruleId: "CISC-ND-000720",
      config: "line con 0\n exec-timeout 5 0\n!\nline vty 0 4\n exec-timeout 5 0\n!\nno ip http server\nno ip http secure-server\n",
      expectStatusKind: "pass" },
    { name: "000720: HTTP enabled with no timeout-policy is Open", ruleId: "CISC-ND-000720",
      config: "line con 0\n exec-timeout 5 0\n!\nline vty 0 4\n exec-timeout 5 0\n!\nip http secure-server\n",
      expectStatusKind: "fail" },
    { name: "000720: HTTP enable/disable state ambiguous defers to manual", ruleId: "CISC-ND-000720",
      config: "line con 0\n exec-timeout 5 0\n!\nline vty 0 4\n exec-timeout 5 0\n!\n",
      expectStatusKind: "manual" },

    { name: "001030: vrf-scoped server counts as a second unique source", ruleId: "CISC-ND-001030",
      config: "ntp server 10.1.1.1\nntp server vrf MGMT 10.1.1.2\n",
      expectStatusKind: "pass" },
    { name: "001030: only one unique server fails", ruleId: "CISC-ND-001030",
      config: "ntp server 10.1.1.1\n",
      expectStatusKind: "fail" },

    { name: "001150: one authenticated + one unauthenticated server fails", ruleId: "CISC-ND-001150",
      config: "ntp authenticate\nntp authentication-key 5 sha1 xxx\nntp trusted-key 5\nntp server 10.1.1.1 key 5\nntp server 10.1.1.2\n",
      expectStatusKind: "fail" },

    { name: "001200: no explicit ssh version defers to manual (not auto-Open)", ruleId: "CISC-ND-001200",
      config: "hostname x\n",
      expectStatusKind: "manual" },
    { name: "001200: version set, no explicit MAC restriction defers to manual", ruleId: "CISC-ND-001200",
      config: "ip ssh version 2\n",
      expectStatusKind: "manual" },
    { name: "001200: explicit weak MAC is Open", ruleId: "CISC-ND-001200",
      config: "ip ssh version 2\nip ssh server algorithm mac hmac-sha1\n",
      expectStatusKind: "fail" },

    { name: "001370 (V-220617): modern 'tacacs server NAME / address ipv4' syntax", ruleId: "CISC-ND-001370",
      config: "aaa new-model\naaa authentication login default group tacacs+ local\ntacacs server T1\n address ipv4 10.0.0.1\n!\ntacacs server T2\n address ipv4 10.0.0.2\n!\n",
      expectStatusKind: "pass" },
    { name: "001370 (V-220565): 'aaa group server tacacs+ / server-private' syntax", ruleId: "CISC-ND-001370",
      config: "aaa new-model\naaa authentication login default group tacacs+ local\naaa group server tacacs+ tacacs\n server-private 1.1.1.1 key 7 x\n server-private 2.2.2.2 key 7 x\n",
      expectStatusKind: "pass" },
    { name: "001370: custom-named AAA group resolves to its declared type", ruleId: "CISC-ND-001370",
      config: "aaa new-model\naaa authentication login default group CorpAAA local\naaa group server tacacs+ CorpAAA\n server-private 5.5.5.5 key 7 x\n server-private 6.6.6.6 key 7 x\n",
      expectStatusKind: "pass" },
    { name: "001370: 1 TACACS+ + 1 RADIUS doesn't satisfy either's redundancy", ruleId: "CISC-ND-001370",
      config: "aaa new-model\naaa authentication login default group tacacs+ local\ntacacs-server host 10.0.0.1\nradius-server host 10.0.0.2\n",
      expectStatusKind: "fail" },

    { name: "000090: archive log config logging enable present", ruleId: "CISC-ND-000090",
      config: "archive\n log config\n  logging enable\n!\n",
      expectStatusKind: "pass" },
    { name: "000090: no archive block fails", ruleId: "CISC-ND-000090",
      config: "hostname x\n",
      expectStatusKind: "fail" },
    { name: "000100: shared archive helper wired correctly", ruleId: "CISC-ND-000100",
      config: "archive\n log config\n  logging enable\n!\n", expectStatusKind: "pass" },
    { name: "000110: shared archive helper wired correctly", ruleId: "CISC-ND-000110",
      config: "archive\n log config\n  logging enable\n!\n", expectStatusKind: "pass" },
    { name: "000120: shared archive helper wired correctly", ruleId: "CISC-ND-000120",
      config: "archive\n log config\n  logging enable\n!\n", expectStatusKind: "pass" },
    { name: "000330: shared archive helper wired correctly", ruleId: "CISC-ND-000330",
      config: "archive\n log config\n  logging enable\n!\n", expectStatusKind: "pass" },
    { name: "000880: shared archive helper wired correctly", ruleId: "CISC-ND-000880",
      config: "archive\n log config\n  logging enable\n!\n", expectStatusKind: "pass" },
    { name: "001250: shared archive helper wired correctly", ruleId: "CISC-ND-001250",
      config: "archive\n log config\n  logging enable\n!\n", expectStatusKind: "pass" },
    { name: "001270: shared archive helper wired correctly", ruleId: "CISC-ND-001270",
      config: "archive\n log config\n  logging enable\n!\n", expectStatusKind: "pass" },

    { name: "000210: logging userinfo alone is not sufficient", ruleId: "CISC-ND-000210",
      config: "logging userinfo\n",
      expectStatusKind: "fail" },
    { name: "000210: both logging userinfo AND archive block present", ruleId: "CISC-ND-000210",
      config: "logging userinfo\narchive\n log config\n  logging enable\n!\n",
      expectStatusKind: "pass" },

    // -------------------------------------------------------------------
    // Router platform (Cisco IOS-XR Switch/Router NDM+RTR STIGs) - a
    // separate check table entirely, since the Router NDM STIG reuses the
    // switch's exact rule_version IDs for different command syntax. Every
    // case here is grounded in the real check_content of an actual .cklb
    // export (verified during this platform's development), not guessed.
    // -------------------------------------------------------------------
    { name: "router 000010: ssh server session-limit present", ruleId: "CISC-ND-000010", platform: "router",
      config: "ssh server session-limit 10\n", expectStatusKind: "pass" },
    { name: "router 000010: no session-limit at all", ruleId: "CISC-ND-000010", platform: "router",
      config: "hostname R1\n", expectStatusKind: "fail" },

    { name: "router 000140: line default access-class present", ruleId: "CISC-ND-000140", platform: "router",
      config: "line default\n access-class ingress MGMT\n!\n", expectStatusKind: "pass" },
    { name: "router 000140: no access-class, but MPP configured defers to manual", ruleId: "CISC-ND-000140", platform: "router",
      config: "control-plane\n management-plane\n  inband\n   interface all\n    allow SSH peer\n     address ipv4 10.0.0.0/24\n!\n",
      expectStatusKind: "manual" },
    { name: "router 000140: neither access-class nor MPP is Open", ruleId: "CISC-ND-000140", platform: "router",
      config: "hostname R1\n", expectStatusKind: "fail" },

    { name: "router 000150: remote auth group mitigates lockout requirement", ruleId: "CISC-ND-000150", platform: "router",
      config: "aaa authentication login default group tacacs+ local\n", expectStatusKind: "pass" },

    { name: "router 000160 (shared with switch): banner login required, not banner motd", ruleId: "CISC-ND-000160", platform: "router",
      config: "banner motd ^\nWelcome\n^\n", expectStatusKind: "fail" },

    { name: "router 000290: plain 'log' is not 'log-input'", ruleId: "CISC-ND-000290", platform: "router",
      config: "ipv4 access-list ACL1\n 10 deny ipv4 any any log\n!\n", expectStatusKind: "fail" },
    { name: "router 000290: log-input satisfies the requirement", ruleId: "CISC-ND-000290", platform: "router",
      config: "ipv4 access-list ACL1\n 10 deny ipv4 any any log-input\n!\n", expectStatusKind: "pass" },

    { name: "router 000490: root-lr group is explicitly disallowed", ruleId: "CISC-ND-000490", platform: "router",
      config: "username localadmin\n group root-lr\n secret 9 x\n!\n", expectStatusKind: "fail" },
    { name: "router 000490: non-disallowed group with 1 account defers to manual", ruleId: "CISC-ND-000490", platform: "router",
      config: "username localadmin\n group netadmin\n secret 9 x\n!\n", expectStatusKind: "manual" },

    { name: "router 000530/001200/001210: ssh v1 not assumed safe (unlike switch)", ruleId: "CISC-ND-001200", platform: "router",
      config: "hostname R1\n", expectStatusKind: "fail" },
    { name: "router 001200: ssh server v2 present", ruleId: "CISC-ND-001200", platform: "router",
      config: "ssh server v2\n", expectStatusKind: "pass" },

    { name: "router 000720: line console/default exec-timeout parsed (IOS-XR headers)", ruleId: "CISC-ND-000720", platform: "router",
      config: "line console\n exec-timeout 5 0\n!\nline default\n exec-timeout 10 0\n!\n", expectStatusKind: "fail" },

    { name: "router 000980: buffered size alone isn't enough, needs archive too", ruleId: "CISC-ND-000980", platform: "router",
      config: "logging buffered 512000\n", expectStatusKind: "fail" },
    { name: "router 000980: buffered + logging archive device satisfies it", ruleId: "CISC-ND-000980", platform: "router",
      config: "logging buffered 512000\nlogging archive\n device harddisk\n!\n", expectStatusKind: "pass" },

    { name: "router 001030: NTP servers nested inside the 'ntp' mode block", ruleId: "CISC-ND-001030", platform: "router",
      config: "ntp\n server 10.1.1.1\n server 10.1.1.2\n!\n", expectStatusKind: "pass" },
    { name: "router 001030: only one NTP server inside the block", ruleId: "CISC-ND-001030", platform: "router",
      config: "ntp\n server 10.1.1.1\n!\n", expectStatusKind: "fail" },

    { name: "router 001140: DES priv is not FIPS 140-2 approved", ruleId: "CISC-ND-001140", platform: "router",
      config: "snmp-server user U G v3 auth sha x priv des x\n", expectStatusKind: "fail" },
    { name: "router 001140: AES priv passes", ruleId: "CISC-ND-001140", platform: "router",
      config: "snmp-server user U G v3 auth sha x priv aes 128 x\n", expectStatusKind: "pass" },

    { name: "router 001150: MD5 IS a finding here (unlike switch's NTP rule)", ruleId: "CISC-ND-001150", platform: "router",
      config: "ntp\n authenticate\n authentication-key 1 md5 x\n trusted-key 1\n server 10.1.1.1 key 1\n!\n", expectStatusKind: "fail" },
    { name: "router 001150: hmac-sha2 passes", ruleId: "CISC-ND-001150", platform: "router",
      config: "ntp\n authenticate\n authentication-key 1 hmac-sha2 x\n trusted-key 1\n server 10.1.1.1 key 1\n!\n", expectStatusKind: "pass" },

    { name: "router 001370: only 1 unique tacacs server fails redundancy", ruleId: "CISC-ND-001370", platform: "router",
      config: "aaa authentication login default group tacacs+ local\ntacacs-server host 10.0.0.1\n", expectStatusKind: "fail" },
    { name: "router 001370: 2 unique tacacs servers passes", ruleId: "CISC-ND-001370", platform: "router",
      config: "aaa authentication login default group tacacs+ local\ntacacs-server host 10.0.0.1\ntacacs-server host 10.0.0.2\n", expectStatusKind: "pass" },

    { name: "router 001440: no trustpoint at all is not_applicable", ruleId: "CISC-ND-001440", platform: "router",
      config: "hostname R1\n", expectStatusKind: "not_applicable" },
    { name: "router 001440: trustpoint present defers to manual (CA trust needs human review)", ruleId: "CISC-ND-001440", platform: "router",
      config: "crypto pki trustpoint CA1\n enrollment url http://ca.example.com\n!\n", expectStatusKind: "manual" },

    { name: "router 001450: only 1 unique syslog server fails the >=2 requirement", ruleId: "CISC-ND-001450", platform: "router",
      config: "logging 10.1.1.1 vrf default severity info\n", expectStatusKind: "fail" },
    { name: "router 001450: 2 unique syslog servers passes", ruleId: "CISC-ND-001450", platform: "router",
      config: "logging 10.1.1.1 vrf default severity info\nlogging 10.1.1.2 vrf default severity info\n", expectStatusKind: "pass" },

    { name: "RT-000160: directed-broadcast disabled on all interfaces", ruleId: "CISC-RT-000160", platform: "router",
      config: "interface Gi0/0/0/0\n ipv4 address 10.1.1.1 255.255.255.0\n!\n", expectStatusKind: "pass" },
    { name: "RT-000160: directed-broadcast enabled is a finding", ruleId: "CISC-RT-000160", platform: "router",
      config: "interface Gi0/0/0/0\n ipv4 address 10.1.1.1 255.255.255.0\n ipv4 directed-broadcast\n!\n", expectStatusKind: "fail" },

    { name: "RT-000200: any log (plain or log-input) satisfies the lenient ACL logging rule", ruleId: "CISC-RT-000200", platform: "router",
      config: "ipv4 access-list ACL1\n 10 deny ipv4 any any log\n!\n", expectStatusKind: "pass" },

    { name: "RT-000350: ipv4 source-route absent is compliant (default)", ruleId: "CISC-RT-000350", platform: "router",
      config: "hostname R1\n", expectStatusKind: "pass" },
    { name: "RT-000350: ipv4 source-route explicitly enabled is a finding", ruleId: "CISC-RT-000350", platform: "router",
      config: "ipv4 source-route\n", expectStatusKind: "fail" },

    { name: "RT-000360: LLDP not enabled globally is compliant by default", ruleId: "CISC-RT-000360", platform: "router",
      config: "hostname R1\n", expectStatusKind: "pass" },

    // -------------------------------------------------------------------
    // Juniper platform (Junos Router NDM+RTR STIGs) - a hierarchical
    // curly-brace config, not line-oriented IOS commands, so this also
    // exercises the brace-depth block parser itself, not just regexes.
    // Every case grounded in the real check_content of an actual .cklb
    // export verified during this platform's development.
    // -------------------------------------------------------------------
    { name: "juniper 000010: connection-limit present", ruleId: "JUNI-ND-000010", platform: "juniper",
      config: "services {\n    ssh {\n        connection-limit 10;\n    }\n}\n", expectStatusKind: "pass" },
    { name: "juniper 000010: no connection-limit at all", ruleId: "JUNI-ND-000010", platform: "juniper",
      config: "system {\n    host-name R1;\n}\n", expectStatusKind: "fail" },

    { name: "juniper audit-event cluster: 'any' satisfies every variant", ruleId: "JUNI-ND-000090", platform: "juniper",
      config: "syslog {\n    host 10.1.1.1 {\n        any info;\n    }\n}\n", expectStatusKind: "pass" },
    { name: "juniper audit-event cluster: specific class satisfies without 'any'", ruleId: "JUNI-ND-000090", platform: "juniper",
      config: "syslog {\n    file LOG_FILE {\n        change-log info;\n    }\n}\n", expectStatusKind: "pass" },
    { name: "juniper audit-event cluster: no matching class at all is a finding", ruleId: "JUNI-ND-000090", platform: "juniper",
      config: "syslog {\n    file LOG_FILE {\n        authorization info;\n    }\n}\n", expectStatusKind: "fail" },
    { name: "juniper 000930: requires BOTH interactive-commands AND change-log (not just one)", ruleId: "JUNI-ND-000930", platform: "juniper",
      config: "syslog {\n    file LOG_FILE {\n        change-log info;\n    }\n}\n", expectStatusKind: "fail" },
    { name: "juniper 000930: both classes together passes", ruleId: "JUNI-ND-000930", platform: "juniper",
      config: "syslog {\n    file LOG_FILE {\n        change-log info;\n        interactive-commands info;\n    }\n}\n", expectStatusKind: "pass" },

    { name: "juniper 000140/001210/RT-120/RT-130: lo0 filter present defers to manual", ruleId: "JUNI-ND-000140", platform: "juniper",
      config: "interfaces {\n    lo0 {\n        unit 0 {\n            family inet {\n                filter {\n                    input PROTECT-RE;\n                }\n            }\n        }\n    }\n}\n",
      expectStatusKind: "manual" },
    { name: "juniper 000140: no lo0 filter at all is Open", ruleId: "JUNI-ND-000140", platform: "juniper",
      config: "interfaces {\n    lo0 {\n        unit 0 {\n            family inet {\n                address 10.1.1.1/32;\n            }\n        }\n    }\n}\n",
      expectStatusKind: "fail" },

    { name: "juniper 000150: 3 tries / 15 min lockout passes", ruleId: "JUNI-ND-000150", platform: "juniper",
      config: "login {\n    retry-options {\n        tries-before-disconnect 3;\n        lockout-period 15;\n    }\n}\n", expectStatusKind: "pass" },
    { name: "juniper 000150: lockout period too short fails", ruleId: "JUNI-ND-000150", platform: "juniper",
      config: "login {\n    retry-options {\n        tries-before-disconnect 3;\n        lockout-period 5;\n    }\n}\n", expectStatusKind: "fail" },

    { name: "juniper 000160: banner message present defers to manual", ruleId: "JUNI-ND-000160", platform: "juniper",
      config: 'login {\n    message "Authorized use only.";\n}\n', expectStatusKind: "manual" },
    { name: "juniper 000160: no message at all is Open", ruleId: "JUNI-ND-000160", platform: "juniper",
      config: "system {\n    host-name R1;\n}\n", expectStatusKind: "fail" },

    { name: "juniper 000470: telnet enabled is a finding", ruleId: "JUNI-ND-000470", platform: "juniper",
      config: "services {\n    telnet;\n}\n", expectStatusKind: "fail" },
    { name: "juniper 000470: only ssh configured passes", ruleId: "JUNI-ND-000470", platform: "juniper",
      config: "services {\n    ssh {\n        protocol-version v2;\n    }\n}\n", expectStatusKind: "pass" },

    { name: "juniper 000530/001190/001200: no explicit macs/ciphers is Open (no safe-default leniency)", ruleId: "JUNI-ND-000530", platform: "juniper",
      config: "services {\n    ssh {\n        protocol-version v2;\n    }\n}\n", expectStatusKind: "fail" },
    { name: "juniper 000530: explicit macs passes", ruleId: "JUNI-ND-000530", platform: "juniper",
      config: "services {\n    ssh {\n        macs [ hmac-sha2-256 ];\n    }\n}\n", expectStatusKind: "pass" },

    { name: "juniper 000550: minimum-length 15 passes", ruleId: "JUNI-ND-000550", platform: "juniper",
      config: "login {\n    password {\n        minimum-length 15;\n    }\n}\n", expectStatusKind: "pass" },
    { name: "juniper 000550: minimum-length 8 fails", ruleId: "JUNI-ND-000550", platform: "juniper",
      config: "login {\n    password {\n        minimum-length 8;\n    }\n}\n", expectStatusKind: "fail" },

    { name: "juniper 000710: idle-timeout parsed from nested login/class block", ruleId: "JUNI-ND-000710", platform: "juniper",
      config: "login {\n    class ADMIN {\n        idle-timeout 10;\n    }\n}\n", expectStatusKind: "fail" },
    { name: "juniper 000710: idle-timeout <= 5 passes", ruleId: "JUNI-ND-000710", platform: "juniper",
      config: "login {\n    class ADMIN {\n        idle-timeout 5;\n    }\n}\n", expectStatusKind: "pass" },

    { name: "juniper 001120/001130: SNMPv3 user block distinguished from login user block", ruleId: "JUNI-ND-001120", platform: "juniper",
      config: "snmp {\n    v3 {\n        usm {\n            local-engine {\n                user snmpadmin {\n                    authentication-sha {\n                        authentication-key \"x\";\n                    }\n                }\n            }\n        }\n    }\n}\n",
      expectStatusKind: "pass" },
    { name: "juniper 001130: DES priv is not FIPS 140-2 approved", ruleId: "JUNI-ND-001130", platform: "juniper",
      config: "snmp {\n    v3 {\n        usm {\n            local-engine {\n                user U {\n                    authentication-sha {\n                        authentication-key \"x\";\n                    }\n                    privacy-des {\n                        privacy-key \"x\";\n                    }\n                }\n            }\n        }\n    }\n}\n",
      expectStatusKind: "fail" },

    { name: "juniper 001140: MD5 IS accepted here (unlike Cisco Router's equivalent NTP rule)", ruleId: "JUNI-ND-001140", platform: "juniper",
      config: "ntp {\n    authentication-key 1 type md5 value \"x\";\n    trusted-key [1];\n    server 10.1.1.1 key 1;\n}\n",
      expectStatusKind: "pass" },

    { name: "juniper 001360: only 1 unique tacplus server fails redundancy", ruleId: "JUNI-ND-001360", platform: "juniper",
      config: "authentication-order [ tacplus password ];\ntacplus-server {\n    10.10.10.5 {\n        secret \"x\";\n    }\n}\n",
      expectStatusKind: "fail" },
    { name: "juniper 001360: 2 unique tacplus servers passes", ruleId: "JUNI-ND-001360", platform: "juniper",
      config: "authentication-order [ tacplus password ];\ntacplus-server {\n    10.10.10.5 {\n        secret \"x\";\n    }\n    10.10.10.6 {\n        secret \"x\";\n    }\n}\n",
      expectStatusKind: "pass" },

    { name: "juniper 001400: transfer-on-commit present passes", ruleId: "JUNI-ND-001400", platform: "juniper",
      config: "archival {\n    configuration {\n        transfer-on-commit;\n    }\n}\n", expectStatusKind: "pass" },

    { name: "juniper 001440: only 1 unique syslog host fails the >=2 requirement", ruleId: "JUNI-ND-001440", platform: "juniper",
      config: "syslog {\n    host 10.1.1.1 {\n        any info;\n    }\n}\n", expectStatusKind: "fail" },
    { name: "juniper 001440: 2 unique syslog hosts passes", ruleId: "JUNI-ND-001440", platform: "juniper",
      config: "syslog {\n    host 10.1.1.1 {\n        any info;\n    }\n    host 10.1.1.2 {\n        any info;\n    }\n}\n", expectStatusKind: "pass" },

    { name: "juniper RT-000070: telnet enabled is a finding", ruleId: "JUNI-RT-000070", platform: "juniper",
      config: "services {\n    telnet;\n}\n", expectStatusKind: "fail" },

    { name: "juniper RT-000200/210/220: unlogged discard term is a finding", ruleId: "JUNI-RT-000200", platform: "juniper",
      config: "firewall {\n    family inet {\n        filter F {\n            term DENY {\n                then {\n                    discard;\n                }\n            }\n        }\n    }\n}\n",
      expectStatusKind: "fail" },
    { name: "juniper RT-000200: logged discard term passes", ruleId: "JUNI-RT-000200", platform: "juniper",
      config: "firewall {\n    family inet {\n        filter F {\n            term DENY {\n                then {\n                    log;\n                    discard;\n                }\n            }\n        }\n    }\n}\n",
      expectStatusKind: "pass" },

    { name: "juniper RT-000350: ip-options blocked with discard action", ruleId: "JUNI-RT-000350", platform: "juniper",
      config: "firewall {\n    family inet {\n        filter F {\n            term DROP_OPTS {\n                from {\n                    ip-options any;\n                }\n                then {\n                    log;\n                    discard;\n                }\n            }\n        }\n    }\n}\n",
      expectStatusKind: "pass" },
    { name: "juniper RT-000350: no ip-options handling at all is a finding", ruleId: "JUNI-RT-000350", platform: "juniper",
      config: "firewall {\n    family inet {\n        filter F {\n            term ALLOW {\n                then accept;\n            }\n        }\n    }\n}\n",
      expectStatusKind: "fail" }
  ];

  function runSelfTests() {
    return TEST_CASES.map(tc => {
      let statusKindActual = null, detailActual = "", evidenceActual = [], errorMsg = null;
      try {
        const table = tc.platform === "router" ? ROUTER_RULE_CHECKS : tc.platform === "juniper" ? JUNIPER_RULE_CHECKS : RULE_CHECKS;
        const cc = getCcPolicyBlock(tc.config);
        const raw = table[tc.ruleId](tc.config, cc);
        if (raw == null) {
          statusKindActual = "(declined)";
        } else {
          const norm = normalizeCheckResult(raw);
          statusKindActual = norm.statusKind;
          detailActual = norm.detail;
          evidenceActual = norm.evidence || [];
        }
      } catch (e) {
        errorMsg = e.message;
      }

      let pass = true;
      const reasons = [];
      if (errorMsg) {
        pass = false;
        reasons.push("threw an error: " + errorMsg);
      } else {
        if (tc.expectStatusKind && statusKindActual !== tc.expectStatusKind) {
          pass = false;
          reasons.push(`expected status "${tc.expectStatusKind}", got "${statusKindActual}"`);
        }
        if (tc.expectEvidenceContains) {
          const hay = (evidenceActual.join(" | ") + " " + detailActual).toLowerCase();
          if (!hay.includes(tc.expectEvidenceContains.toLowerCase())) {
            pass = false;
            reasons.push(`expected evidence/detail to mention "${tc.expectEvidenceContains}"`);
          }
        }
      }

      return { name: tc.name, ruleId: tc.ruleId, pass, actual: errorMsg ? ("error: " + errorMsg) : statusKindActual, reasons };
    });
  }

  const selfTestVersionEl = document.getElementById("selfTestVersion");
  if (selfTestVersionEl) selfTestVersionEl.textContent = TOOL_VERSION;

  document.getElementById("runSelfTestsBtn").addEventListener("click", () => {
    const results = runSelfTests();
    const panel = document.getElementById("selfTestResults");
    panel.classList.remove("hidden");
    const passCount = results.filter(r => r.pass).length;
    const allPass = passCount === results.length;
    const rowsHtml = results.map(r => {
      const mark = r.pass ? "✓" : "✗";
      const reasonHtml = (!r.pass && r.reasons.length) ? `<div class="st-detail">${escapeHtml(r.reasons.join("; "))}</div>` : "";
      return `<div class="self-test-row ${r.pass ? "pass" : "fail"}">` +
        `<span class="st-mark">${mark}</span>` +
        `<span class="st-name">${escapeHtml(r.name)}</span>` +
        `<span class="st-rule">${escapeHtml(r.ruleId)}</span>` +
        reasonHtml +
        `</div>`;
    }).join("");
    panel.innerHTML = `<div class="self-test-summary ${allPass ? "all-pass" : "has-fail"}">${passCount} / ${results.length} passed</div>` + rowsHtml;
  });
})();
</script>
</body>
</html>
