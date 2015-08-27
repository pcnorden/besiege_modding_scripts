###################################################################
# This script would never see the light of the day if it wasn't   #
# for the people that created Besiege, and me(just kiddin!)       #
#                                                                 #
# For me to be allowed to spread this script, you will find a     #
# file called "LICENSE" in the same place as the script will      #
# be located, because that is what spaar wanted me to add, and    #
# give him credits.                                               #
#                                                                 #
# One other person that would like to also be mentioned is bobd132#
# from the besiege forums because his awesome mod that this script#
# will also likely install!                                       #
#                                                                 #
# So, TL;DR: Credits to spaar and bobd132 from the besiege forums!#
###################################################################

#If you don't want the multimod, change "false" to "true" down below!
$skip_multimod = "true";
#Note: currently the new multimod for besiege fails to load, so the setting has been set to true.
#I will update the reddit post as soon as the multimod starts to work again, and after pushing the
#update to github where the links are after verifying they work!

#Global values, don't piss them off!
$modloader_link = "";
$multimod_link = "";

function unzip(){
	$shell_app = new-object -com shell.application;
	$zip_file = $shell_app.namespace((Get-Location).Path + "\modloader.zip");
	$dest = $shell_app.namespace((Get-Location).Path + "\tempworkspace");
	$dest.Copyhere($zip_file.items());
}
function downloadModloader(){
	$outfile = (Get-Location).Path + "\modloader.zip";
	$client = new-object System.Net.WebClient;
	$client.DownloadFile($modloader_link, $outfile);
}
#This function is to check if the directorys that this install script will use are there.
#Do not tamper with it unless you know what you are doing!
function setup(){
	$test_1 = Test-Path ((Get-Location).Path + "\tempworkspace");
	if(!$test_1){
		ni "tempworkspace" -type directory;
	}
	$test_2 = Test-Path ((Get-Location).Path + "\backup");
	if(!$test_2){
		ni "backup" -type directory;
	}
}
#This function is to get the latest links to the modloader and multimod!
#Do not tamper with this function, as it is the core function of this script!
function getlinks(){
	$outfile = ((Get-Location).Path + "\tempworkspace\links.txt");
	$url = "https://raw.githubusercontent.com/pcnorden/pcnorden.github.io/master/links.txt";
	$client = new-object System.Net.WebClient;
	$client.DownloadFile($url, $outfile);
	$links = Get-Content $outfile;
	modloader_link = $links[0];
	multimod_link = $links[1];
	Remove-Item $outfile;
}
#Done:
#Credits that are at the top of the script!
#
#//TODO:
#Setup
#getlinks
#downloadModloader
#installmodloader
#check if user want's multimod
##installmultimod
#quit
function backup(){
	$dir = ((Get-Location).Path);
	$test_1 = Test-Path "$dir\Besiege_Data\Managed\Assebly-UnityScript.dll";
	if(!$test_1){
		Write-Host -ForegroundColor RED "There is no Assebly-UnityScript.dll in $dir\Besiege_Data\Managed!";
		Write-Host -ForegroundColor RED "Aborting...";
		exit;
	}
	mv "$dir\Besiege_Data\Managed\Assebly-UnityScript.dll" "$dir\backup";
}
function installmodloader(){
	$dir = ((Get-Location).Path);
	ni "$dir\Besiege_Data\Mods" -type directory;
	mv "$dir\tempworkspace\Assebly-UnityScript.dll" "$dir\Besiege_Data\Managed\Assebly-UnityScript.dll";
	mv "$dir\tempworkspace\LICENSE" "$dir\LICENSE";
	mv "$dir\tempworkspace\SpaarModLoader.dll" "$dir\Besiege_Data\Mods\SpaarModLoader.dll";
}
function cleanup(){
	#Don't we all hate cleaning our rooms?
	$dir = ((Get-Location).Path);
	Remove-Item "$dir\tempworkspace\*";
	Remove-Item "$dir\tempworkspace";
}
function installmultimod(){
	$dir = ((Get-Location).Path + "\mods\multimod.dll");
	$client = new-object System.Net.WebClient;
	$client.DownloadFile($multimod_link, $dir);
}
function caller(){
	#The call : https://www.youtube.com/watch?v=7XuVXeLaKNU
	setup;
	getlinks;
	downloadModloader;
	installmodloader;
	if($skip_multimod -match "false"){
		installmultimod;
		cleanup;
		Write-Host -ForegroundColor GRENN "Done!";
		Write-Host -ForegroundColor GREEN "Big thanks to spaar and bobd132 on the besiege";
		Write-Host -ForegroundColor GREEN "forum for letting me share this script!"
		exit;
	}else{
		cleanup;
		Write-Host -ForegroundColor GREEN "Done!";
		Write-Host -ForegroundColor GREEN "Big thanks to spaar and bobd132 on the besiege";
		Write-Host -ForegroundColor GREEN "forum for letting me share this script!";
		Write-Host "(even tho you didn't want bobd132's multimod...)";
		exit;
	}
}
