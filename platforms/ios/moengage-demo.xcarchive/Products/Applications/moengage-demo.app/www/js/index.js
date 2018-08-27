/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },

    // deviceready Event Handler
    //
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
    onDeviceReady: function() {
        this.receivedEvent('deviceready');
        var moe = new MoECordova.init();
        moe.setLogLevelForiOS(1);
        moe.trackEvent("testEvent", {"attr" : 1});
        moe.registerForPushNotification()

        var eventDict1 = {
            "attributeKey" : "attributeValue"
        }
        moe.trackEvent("Event1",eventDict1)


        var eventDict2 = {
            "attributeKeyBool" : true
        }
        moe.trackEvent("Event2",eventDict2)

        
        var eventDict3 = {
            "attributeKeyNumber" : 2333
        }
        moe.trackEvent("Event3",eventDict3)

        
        var eventDict4 = {
            "attributeKeyDecimal" : 2.34
        }
        moe.trackEvent("Event4",eventDict4)

        moe.trackEvent("Event5",null)

        moe.setExistingUser(true)

        moe.setUserAttribute("USER_ATTRIBUTE_UNIQUE_ID", "ID1")
        moe.setUserAttribute("TEST_NUMBER", 23)
        moe.setUserAttribute("TEST_BOOL", true)
        moe.setUserAttribute("TEST_STRING", "HELLO")

        moe.setUserAttributeTimestamp("TEST_TIME",1470288682)
        moe.setAlias("ID2")
        moe.setUserAttributeLocation("TEST_LOCATION",72.0089,54.0009)

        moe.showInApp()

        moe.on('onPushClick', function(data) {
            console.log('Received data: ' + data);
        });

        moe.on('onPushRegistration', function(data) {
            console.log('Received data: ' + data);
        });

        moe.on('onInAppShown', function(data) {
            console.log('Received data: ' + data);
        });

        moe.on('onInAppClick', function(data) {
            console.log('Received data: ' + data);
        });
    },

    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
        
    }
};

app.initialize();
