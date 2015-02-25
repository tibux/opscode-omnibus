define_upgrade do

  if Partybus.config.bootstrap_server

    must_be_data_master

    # run 2.4.0 migrations to update db - includes adding org association/user tables
    # and adding the OSC password hash types to the password_hash_type_enum
    run_command("make deploy",
                :cwd => "/opt/opscode/embedded/service/opscode-erchef/schema",
                :env => {"EC_TARGET" => "@2.4.0", "OSC_TARGET" => "@1.0.4",  "DB_USER" => Partybus.config.database_unix_user}
                )

  end
end
