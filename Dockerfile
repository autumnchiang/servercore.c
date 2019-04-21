# Dockerfile :
#     servercore.c

Arg imageVersion="latest"

# For the image servercore.c :
# servercore.c

# Building image..

From servercore:${imageVersion}

Label maintainer="Autumn Chiang <autumn.snoopy@hotmail.com>"
Label package.ca.version="20190228"
Label package.ca.pkg.digests="11A8614AFC86"
Label package.ca.pkg.description="Certificate Authority"
Label package.PowerShell.version="6.2.0"
Label package.PowerShell.pkg.digests="C02AF438D3BC"
Label package.PowerShell.pkg.description="PowerShell core is a cross-platform command line shell and scripting language."

User ContainerAdministrator

# installing..
# installing package ca..
Arg package_ca_name="CA"
Arg package_ca_version="Latest"
Arg package_ca_installdir="C:/Certs"
    # get archive..
    Add archive/package/#CA/${package_ca_version} ${package_ca_installdir}/
Run certoc.exe -addstore Root %package_ca_installdir%/CA.cer

# installing package PowerShell..
Arg package_PowerShell_name="PowerShell"
Arg package_PowerShell_version="6.2.0"
Arg package_PowerShell_installdir="C:/Program Files/PowerShell"
    # get archive..
    Add archive/package/PowerShell/${package_PowerShell_version} C:/archives/
Run powershell -Command \
    Expand-Archive -Path C:/archives/PowerShell-$Env:package_PowerShell_version.zip -DestinationPath $Env:package_PowerShell_installdir ; \
    # cleanup..
    Remove-Item -Path C:/archives -Recurse -Force

# post-install..*
# configuring env..
Run setx.exe /m PATH "%PATH%;%package_PowerShell_installdir%"

# Configuring image..

#Shell ["powershell.exe","-Command"]

Entrypoint ["powershell.exe","-Command"]