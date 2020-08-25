
param(
[Parameter(Mandatory=$False)]
[ValidateSet("1.7","7","1.8","8","11")]
[String]$Java,

[Parameter(Mandatory=$False)]
[ValidateSet("10","11","12","13","2.10","2.11","2.12","2.13","2.10.7","2.11.12","2.12.12","2.13.3")]
[String]$Scala,

[Parameter(Mandatory=$False)]
[ValidateSet("2.6.0","2.7.7","3.2.1","3.3.0")]
[String]$Hadoop,

[Parameter(Mandatory=$False)]
[ValidateSet("ns","ns-2.1.1","2.1.1","2.4.6","3.0.0")]
[String]$Spark
)

# "JAVA_VERSION=$Java"
# "SCALA_VERSION=$Scala"
# "HADOOP_VERSION=$Hadoop"
# "SPARK_VER=$Spark"

$env:OPENSSH_HOME = "C:\opt\software\OpenSSH"
$env:PATH = $env:OPENSSH_HOME + "\bin;" + $env:PATH

$env:TAR_HOME = "C:\opt\software\tar"
$env:PATH = $env:TAR_HOME + "\bin;" + $env:PATH


switch($Java)
{
    {$_ -eq "1.7" -or $_ -eq "7"} { $env:JAVA_HOME = "C:\opt\jdk\jdk1.7.0_80" }
    {$_ -eq "1.8" -or $_ -eq "8"} { $env:JAVA_HOME = "C:\opt\jdk\jdk1.8.0_251" }
    "11" { $env:JAVA_HOME = "C:\opt\jdk\jdk-11.0.7" }
}
if ($env:JAVA_HOME) { $env:PATH = $env:JAVA_HOME + "\bin;" + $env:PATH }

switch($Scala)
{
    {$_ -eq "10" -or $_ -eq "2.10" -or $_ -eq "2.10.7"} { $env:SCALA_HOME = "C:\opt\scala\scala-2.10.7-sdk" }
    {$_ -eq "11" -or $_ -eq "2.11" -or $_ -eq "2.11.12"} { $env:SCALA_HOME = "C:\opt\scala\scala-2.11.12-sdk" }
    {$_ -eq "12" -or $_ -eq "2.12" -or $_ -eq "2.12.12"} { $env:SCALA_HOME = "C:\opt\scala\scala-2.12.12-sdk" }
    {$_ -eq "13" -or $_ -eq "2.13" -or $_ -eq "2.13.3"} { $env:SCALA_HOME = "C:\opt\scala\scala-2.13.3-sdk" }
}
if ($env:SCALA_HOME) { $env:PATH = $env:SCALA_HOME + "\bin;" + $env:PATH }

switch($Hadoop)
{
    "2.6.0" { $env:HADOOP_HOME = "C:\opt\hadoop\hadoop-2.6.0" }
    "2.7.7" { $env:HADOOP_HOME = "C:\opt\hadoop\hadoop-2.7.7" }
    "3.2.1" { $env:HADOOP_HOME = "C:\opt\hadoop\hadoop-3.2.1" }
    "3.3.0" { $env:HADOOP_HOME = "C:\opt\hadoop\hadoop-3.3.0" }
}
if ($env:HADOOP_HOME) { $env:PATH = $env:HADOOP_HOME + "\bin;" + $env:PATH }

switch($Spark)
{
    {$_ -eq "ns" -or $_ -eq "ns-2.1.1" } { $env:SPARK_HOME = "C:\opt\spark\spark-2.1.1-bin-hadoop2.6" }
    "2.1.1" { $env:SPARK_HOME = "C:\opt\spark\spark-2.1.1-bin-hadoop2.6" }
    "2.4.6" { $env:SPARK_HOME = "C:\opt\spark\spark-2.4.6-bin-hadoop2.7" }
    "3.0.0" { $env:SPARK_HOME = "C:\opt\spark\spark-3.0.0-bin-hadoop3.2" }
}
