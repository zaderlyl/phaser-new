#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import readline from 'node:readline/promises';
import { fileURLToPath } from 'node:url';

const NOM_PAR_DEFAUT = 'mon-jeu';
const DOSSIER_MODELE = path.join(path.dirname(fileURLToPath(import.meta.url)), '..', 'templates');
const DOSSIERS_ASSETS = ['sprites', 'audio', 'maps'];

// npm retire les fichiers nommés .gitignore à la publication : le modèle utilise _gitignore
const FICHIERS_RENOMMES = { _gitignore: '.gitignore' };
const EXTENSIONS_TEXTE = ['.html', '.md', '.js'];
const DOSSIER_SANS_REMPLACEMENT = 'libs';

function nomValide(nom) {
  return /^[a-zA-Z0-9_-]+$/.test(nom);
}

async function demanderNom() {
  const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
  const reponse = await rl.question(`Nom du jeu (${NOM_PAR_DEFAUT}) : `);
  rl.close();
  return reponse.trim() || NOM_PAR_DEFAUT;
}

function copierModele(source, destination, nom, dansLibs = false) {
  fs.mkdirSync(destination, { recursive: true });

  for (const entree of fs.readdirSync(source, { withFileTypes: true })) {
    const cheminSource = path.join(source, entree.name);
    const cheminDestination = path.join(destination, FICHIERS_RENOMMES[entree.name] ?? entree.name);

    if (entree.isDirectory()) {
      copierModele(cheminSource, cheminDestination, nom, dansLibs || entree.name === DOSSIER_SANS_REMPLACEMENT);
    } else if (!dansLibs && EXTENSIONS_TEXTE.includes(path.extname(entree.name))) {
      const contenu = fs.readFileSync(cheminSource, 'utf8').replaceAll('__NOM__', nom);
      fs.writeFileSync(cheminDestination, contenu);
    } else {
      fs.copyFileSync(cheminSource, cheminDestination);
    }
  }
}

const nom = process.argv[2] ?? (await demanderNom());

if (!nomValide(nom)) {
  console.error('Erreur : le nom ne peut contenir que des lettres, des chiffres, - et _ (pas d\'espace).');
  process.exit(1);
}

const destination = path.resolve(process.cwd(), nom);

if (fs.existsSync(destination)) {
  console.error(`Erreur : « ${nom} » existe déjà.`);
  process.exit(1);
}

copierModele(DOSSIER_MODELE, destination, nom);

for (const dossier of DOSSIERS_ASSETS) {
  fs.mkdirSync(path.join(destination, 'assets', dossier), { recursive: true });
}

console.log(`Jeu « ${nom} » créé. Pour le lancer :\n`);
console.log(`  cd ${nom}`);
console.log('  npx serve\n');
console.log('Puis ouvre http://localhost:3000');
