{ config, pkgs, ... }:

{
  # Mount options
  fileSystems = {
    "/".options = [ "noatime" "compress=zstd" "space_cache=v2" ];
    "/nix".options = [ "noatime" "compress=zstd" "space_cache=v2" ];
    "/home".options = [ "noatime" "compress=zstd" "space_cache=v2" ];
    "/.snapshots".options = [ "noatime" "compress=zstd" "space_cache=v2" ];
    "/var/log".options = [ "noatime" "compress=zstd" "space_cache=v2" ];
    "/swap".options = [ "noatime" ];
  };
}