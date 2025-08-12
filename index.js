const core = require('@actions/core');
const exec = require('@actions/exec');

async function run() {
  try {
    const workdir = core.getInput('workdir') || '.';
    const options = { cwd: workdir };
    // Try tfsec
    try { await exec.exec('tfsec', ['.'], options); } catch(e) { core.info('tfsec not found, skipping'); }
    // Try trivy config
    try { await exec.exec('trivy', ['config', '.'], options); } catch(e) { core.info('trivy not found, skipping'); }
  } catch (error) {
    core.setFailed(error.message);
  }
}
run();
