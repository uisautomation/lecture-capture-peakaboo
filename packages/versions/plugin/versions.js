"use strict";

class VersionCompiler {
  processFilesForTarget(files) {
    files.forEach((file) => {
      if (file.getDisplayPath() == '/package.json') {
        let versions = {}
        let packageData = JSON.parse(file.getContentsAsString());
        versions.version = packageData.version;

        let head = Plugin.fs.readFileSync('.git/HEAD', {encoding: 'utf8'});
        let ref = head.match(/ref\:\s+(refs\/.+?\/(.+))\s/);
        let refPath = '.git/' + ref[1];
        versions.branch = ref[2];

        let commit = Plugin.fs.readFileSync(refPath, {encoding: 'utf8'});
        versions.commit = commit.trim();

        file.addAsset({
          path: 'versions.json',
          data: JSON.stringify(versions)
        })
      };
    });
  }
}

Plugin.registerCompiler({
  filenames: ['package.json'],
}, () => new VersionCompiler);
