const fs = require('fs');

const path = require('path');

const version = process.env.VERSION;

console.log('*********** VERSION ***********', version);

const basePath = path.resolve(__dirname, '..', 'src/design-system/icons');

console.log('- start clean export icons', basePath);

const files = fs.readdirSync(basePath);
files.forEach(fileName => {
  const filePath = `${basePath}/${fileName}`;
  const content = fs.readFileSync(filePath, { encoding: 'utf-8' });
  fs.writeFileSync(
    filePath,
    content
      .replace('xmlns', '')
      .replace('xmlnsXlink', '')
      .replace('id={15}', ''),
  );
});

fs.renameSync(`${basePath}/index.js`, `${basePath}/index.ts`);

const content = fs.readFileSync(`${basePath}/index.ts`, { encoding: 'utf-8' });
fs.writeFileSync(`${basePath}/index.ts`, content.replace(/.tsx/g, ''));
