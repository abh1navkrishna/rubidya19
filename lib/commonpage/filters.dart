

const SEPIA_MATRIX = [
  0.39, 0.769, 0.189, 0.0, 0.0,
  0.349, 0.686, 0.168, 0.0, 0.0,
  0.272, 0.534, 0.131, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const GREYSCALE_MATRIX = [
  0.2126, 0.7152, 0.0722, 0.0, 0.0,
  0.2126, 0.7152, 0.0722, 0.0, 0.0,
  0.2126, 0.7152, 0.0722, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];


const VINTAGE_MATRIX = [
  0.9, 0.5, 0.1, 0.0, 0.0,
  0.3, 0.8, 0.1, 0.0, 0.0,
  0.2, 0.3, 0.5, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const SWEET_MATRIX = [
  1.0, 0.0, 0.2, 0.0, 0.0,
  0.1126, 0.6152, 0.0744, 0.0, 0.0,
  0.0, 0.0, 1.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const COOL_MATRIX = [1.0, 0.0, 0.6, 0.0, 0.0,
  0.0, 1.0, 0.0, 0.0, 0.0,
  0.8126, 0.9162, 0.0422, 0.0, 0.0,
  0.1, 0.0, 1.0, 1.0, 0.0];

const LEGEND_MATRIX = [
  0.3678, 0.7865, 0.9807, 0.0, 0.0,
  0.2126, 0.8769, 0.9076, 0.0, 0.0,
  0.9078, 0.3478, 0.04, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const ANJU_MATRIX = [
  0.9084, 0.4215, 0.9765, 0.0, 0.0,
  0.2226, 0.8976, 0.9478, 0.0, 0.0,
  0.5647, 0.2756, 0.9075, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const XABI_MATRIX = [
  0.8890, 0.9035, 0.9345, 0.8984, 0.5884,
  0.8985, 0.184, 0.235, 0.8126, 0.0,
  0.1289, 0.76, 0.816, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const SUNSET_MATRIX = [
  0.94, 0.0, 0.0, 0.0, 0.0,
  0.14, 0.56, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.64, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const EMERALD_MATRIX = [
  0.67, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.82, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.67, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const PASTEL_MATRIX = [
  0.8, 0.3, 0.1, 0.0, 0.0,
  0.2, 0.7, 0.2, 0.0, 0.0,
  0.1, 0.3, 0.8, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const GOLDEN_MATRIX = [
  0.98, 0.1, 0.0, 0.0, 0.0,
  0.0, 0.98, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.6, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const OCEAN_MATRIX = [
  0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.56, 0.82, 0.0, 0.0,
  0.94, 0.14, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];
const CHERRY_BLOSSOM_MATRIX = [
  1.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.7, 0.3, 0.0, 0.0,
  0.0, 0.3, 0.7, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const MIDNIGHT_MATRIX = [
  0.1, 0.0, 0.4, 0.0, 0.0,
  0.0, 0.2, 0.8, 0.0, 0.0,
  0.1, 0.0, 0.9, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const FIRE_MATRIX = [
  1.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.5, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const EARTH_MATRIX = [
  0.5, 0.5, 0.0, 0.0, 0.0,
  0.3, 0.7, 0.0, 0.0, 0.0,
  0.1, 0.4, 0.5, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const DESERT_MATRIX = [
  0.8, 0.3, 0.0, 0.0, 0.0,
  0.0, 0.7, 0.2, 0.0, 0.0,
  0.0, 0.2, 0.5, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const AMETHYST_MATRIX = [
  0.8, 0.0, 0.8, 0.0, 0.0,
  0.0, 0.8, 0.0, 0.0, 0.0,
  0.8, 0.0, 0.8, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const LAVENDER_MATRIX = [
  0.8, 0.5, 0.0, 0.0, 0.0,
  0.3, 0.7, 0.0, 0.0, 0.0,
  0.0, 0.5, 0.8, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const RUBY_MATRIX = [
  1.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.3, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.3, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const SAPPHIRE_MATRIX = [
  0.0, 0.0, 1.0, 0.0, 0.0,
  0.0, 0.5, 0.0, 0.0, 0.0,
  1.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const TOPAZ_MATRIX = [
  1.0, 0.2, 0.0, 0.0, 0.0,
  0.1, 0.9, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.5, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const AQUA_MATRIX = [
  0.3, 0.0, 0.8, 0.0, 0.0,
  0.0, 0.7, 0.5, 0.0, 0.0,
  0.8, 0.3, 0.7, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const FOREST_MATRIX = [
  0.6, 0.0, 0.4, 0.0, 0.0,
  0.0, 0.7, 0.0, 0.0, 0.0,
  0.4, 0.0, 0.6, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const PEARL_MATRIX = [
  0.8, 0.2, 0.8, 0.0, 0.0,
  0.2, 0.8, 0.2, 0.0, 0.0,
  0.8, 0.2, 0.8, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const SUNFLOWER_MATRIX = [
  1.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.9, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.5, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const LEMON_MATRIX = [
  0.9, 0.0, 0.0, 0.0, 0.0,
  0.0, 1.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.5, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const ROSE_MATRIX = [
  1.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.6, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.6, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const TURQUOISE_MATRIX = [
  0.7, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.7, 0.7, 0.0, 0.0,
  0.0, 0.0, 0.7, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const PEACH_MATRIX = [
  1.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.7, 0.4, 0.0, 0.0,
  0.0, 0.4, 0.7, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];
