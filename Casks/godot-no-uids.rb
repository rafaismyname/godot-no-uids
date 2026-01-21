cask "godot-no-uids" do
  version :latest
  sha256 :no_check

  url "https://github.com/rafaismyname/godot-no-uids/releases/latest/download/godot.macos.editor.zip"
  name "Godot No-UIDs"
  desc "Godot Engine with UID generation disabled"
  homepage "https://github.com/rafaismyname/godot-no-uids"

  app "Godot.app"
  
  # Conflicts with official Godot if installed via brew cask?
  # conflicts_with cask: "godot"

  zap trash: [
    "~/Library/Application Support/Godot",
    "~/Library/Caches/Godot",
    "~/Library/Saved Application State/org.godotengine.godot.savedState",
  ]
end
