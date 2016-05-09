define postgresql::pgdumpbackup (
                      $destination,
                      $backupname       = $name,
                      $pgroot           = undef,
                      $instance         = undef,
                      $retention        = '7',
                      $dbs              = 'ALL',
                      $mailto           = undef,
                      $idhost           = undef,
                      $basedir          = '/usr/local/bin',
                      $ensure           = 'present',
                      $username         = 'postgres',
                      #cron
                      $setcronjob       = true,
                      $hour_cronjob     = '2',
                      $minute_cronjob   = '0',
                      $month_cronjob    = undef,
                      $monthday_cronjob = undef,
                      $weekday_cronjob  = undef,
                      $setcron_cronjob  = true,
                    ) {

  validate_absolute_path($basedir)
  validate_absolute_path($destination)

  file { "${basedir}/pgdumpbackup.sh":
    ensure => $ensure,
    owner  => 'root',
    group  => $username,
    mode   => '0750',
    source => "puppet:///modules/${module_name}/backup_pgdump.sh",
  }

  file { "${basedir}/pgdumpbackup.config":
    ensure  => $ensure,
    owner   => 'root',
    group   => $username,
    mode    => '0640',
    content => template("${module_name}/backup/backup_pgdump_config.erb"),
  }

  if($setcronjob)
  {
    cron { "cronjob logical postgres backup: ${backupname}":
      command  => "${basedir}/pgdumpbackup.sh",
      user     => $username,
      hour     => $hour_cronjob,
      minute   => $minute_cronjob,
      month    => $month_cronjob,
      monthday => $monthday_cronjob,
      weekday  => $weekday_cronjob,
      require  => File[ [ "${basedir}/pgdumpbackup.config",
                          "${basedir}/pgdumpbackup.sh"
                      ] ],
    }
  }

}
