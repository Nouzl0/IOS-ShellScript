# argument options      
./mole.sh -h                                                    #0 - DONE
        
./mole.sh file                                                  #1 - DONE
./mole.sh -g group file                                         #1 - DONE

./mole.sh                                                       #2 - DONE
./mole.sh -m                                                    #2 - DONE
./mole.sh directory                                             #2 - DONE
./mole.sh -m directory                                          #2 - DONE

./mole.sh -g group                                              #2 - DONE
./mole.sh -a 2010-01-01                                         #2 - DONE
./mole.sh -b 2020-02-02                                         #2 - DONE
./mole.sh -a 2010-01-01 -b 2020-02-02                           #2 - DONE
./mole.sh -g group -a 2010-01-01                                #2 - DONE
./mole.sh -g group -b 2020-02-02                                #2 - DONE
./mole.sh -a 2021-01-01 -g group                                #2 - DONE
./mole.sh -b 2020-02-02 -g group                                #2 - DONE
./mole.sh -a 2010-01-01 -b 2020-02-02 -g group                  #2 - DONE
./mole.sh -b 2020-02-02 -a 2010-01-01 -g group                  #2 - DONE
./mole.sh -a 2010-01-01 -g group -b 2020-02-02                  #2 - DONE
./mole.sh -b 2020-02-02 -g group -a 2010-01-01                  #2 - DONE
./mole.sh -g group -a 2010-01-01 -b 2020-02-02                  #2 - DONE
./mole.sh -g group -b 2020-02-02 -a 2010-01-01                  #2 - DONE

./mole.sh -m -g group                                           #2 - DONE
./mole.sh -m -a 2010-01-01                                      #2 - DONE
./mole.sh -m -b 2020-02-02                                      #2 - DONE
./mole.sh -m -a 2010-01-01 -b 2020-02-02                        #2 - DONE
./mole.sh -m -g group -a 2010-01-01                             #2 - DONE
./mole.sh -m -g group -b 2020-02-02                             #2 - DONE
./mole.sh -m -a 2021-01-01 -g group                             #2 - DONE
./mole.sh -m -b 2020-02-02 -g group                             #2 - DONE
./mole.sh -m -a 2010-01-01 -b 2020-02-02 -g group               #2 - DONE
./mole.sh -m -b 2020-02-02 -a 2010-01-01 -g group               #2 - DONE
./mole.sh -m -a 2010-01-01 -g group -b 2020-02-02               #2 - DONE
./mole.sh -m -b 2020-02-02 -g group -a 2010-01-01               #2 - DONE
./mole.sh -m -g group -b 2020-02-02 -a 2010-01-01               #2 - DONE
./mole.sh -m -g group -a 2010-01-01 -b 2020-02-02               #2 - DONE

./mole.sh -g group directory                                    #2 - DONE
./mole.sh -a 2010-01-01 directory                               #2 - DONE
./mole.sh -b 2020-02-02 directory                               #2 - DONE
./mole.sh -a 2010-01-01 -b 2020-02-02 directory                 #2 - DONE
./mole.sh -g group -a 2010-01-01 directory                      #2 - DONE
./mole.sh -g group -b 2020-02-02 directory                      #2 - DONE
./mole.sh -a 2021-01-01 -g group directory                      #2 - DONE
./mole.sh -b 2020-02-02 -g group directory                      #2 - DONE
./mole.sh -a 2010-01-01 -b 2020-02-02 -g group directory        #2 - DONE
./mole.sh -b 2020-02-02 -a 2010-01-01 -g group directory        #2 - DONE
./mole.sh -a 2010-01-01 -g group -b 2020-02-02 directory        #2 - DONE
./mole.sh -b 2020-02-02 -g group -a 2010-01-01 directory        #2 - DONE
./mole.sh -g group -a 2010-01-01 -b 2020-02-02 directory        #2 - DONE
./mole.sh -g group -b 2020-02-02 -a 2010-01-01 directory        #2 - DONE

./mole.sh -m -g group directory                                 #2 - DONE
./mole.sh -m -a 2010-01-01 directory                            #2 - DONE
./mole.sh -m -b 2020-02-02 directory                            #2 - DONE
./mole.sh -m -a 2010-01-01 -b 2020-02-02 directory              #2 - DONE
./mole.sh -m -g group -a 2010-01-01 directory                   #2 - DONE
./mole.sh -m -g group -b 2020-02-02 directory                   #2 - DONE
./mole.sh -m -a 2021-01-01 -g group directory                   #2 - DONE
./mole.sh -m -b 2020-02-02 -g group directory                   #2 - DONE
./mole.sh -m -a 2010-01-01 -b 2020-02-02 -g group directory     #2 - DONE
./mole.sh -m -b 2020-02-02 -a 2010-01-01 -g group directory     #2 - DONE
./mole.sh -m -a 2010-01-01 -g group -b 2020-02-02 directory     #2 - DONE
./mole.sh -m -b 2020-02-02 -g group -a 2010-01-01 directory     #2 - DONE
./mole.sh -m -g group -a 2010-01-01 -b 2020-02-02 directory     #2 - DONE
./mole.sh -m -g group -b 2020-02-02 -a 2010-01-01 directory     #2 - DONE

./mole.sh list                                                  #3 - DONE
./mole.sh list directory                                        #3 - DONE

./mole.sh list -g group                                         #3 - DONE
./mole.sh list -a 2010-01-01                                    #3 - DONE
./mole.sh list -b 2020-02-02                                    #3 - DONE
./mole.sh list -a 2010-01-01 -b 2020-02-02                      #3 - DONE
./mole.sh list -g group -a 2010-01-01                           #3 - DONE
./mole.sh list -g group -b 2020-02-02                           #3 - DONE
./mole.sh list -a 2021-01-01 -g group                           #3 - DONE
./mole.sh list -b 2020-02-02 -g group                           #3 - DONE
./mole.sh list -a 2010-01-01 -b 2020-02-02 -g group             #3 - DONE
./mole.sh list -b 2020-02-02 -a 2010-01-01 -g group             #3 - DONE
./mole.sh list -a 2010-01-01 -g group -b 2020-02-02             #3 - DONE
./mole.sh list -b 2020-02-02 -g group -a 2010-01-01             #3 - DONE
./mole.sh list -g group -a 2010-01-01 -b 2020-02-02             #3 - DONE
./mole.sh list -g group -b 2020-02-02 -a 2010-01-01             #3 - DONE

./mole.sh list -g group directory                               #3 - DONE
./mole.sh list -a 2010-01-01 directory                          #3 - DONE
./mole.sh list -b 2020-02-02 directory                          #3 - DONE
./mole.sh list -a 2010-01-01 -b 2020-02-02 directory            #3 - DONE
./mole.sh list -g group -a 2010-01-01 directory                 #3 - DONE
./mole.sh list -g group -b 2020-02-02 directory                 #3 - DONE
./mole.sh list -a 2021-01-01 -g group directory                 #3 - DONE
./mole.sh list -b 2020-02-02 -g group directory                 #3 - DONE
./mole.sh list -a 2010-01-01 -b 2020-02-02 -g group directory   #3 - DONE
./mole.sh list -b 2020-02-02 -a 2010-01-01 -g group directory   #3 - DONE
./mole.sh list -a 2010-01-01 -g group -b 2020-02-02 directory   #3 - DONE
./mole.sh list -b 2020-02-02 -g group -a 2010-01-01 directory   #3 - DONE
./mole.sh list -g group -a 2010-01-01 -b 2020-02-02 directory   #3 - DONE
./mole.sh list -g group -b 2020-02-02 -a 2010-01-01 directory   #3 - DONE

./mole.sh secret-log                                            #4 - DONE
./mole.sh secret-log -b 2020-02-02                              #4 - DONE
./mole.sh secret-log -a 2010-01-01                              #4 - DONE
./mole.sh secret-log directory                                  #4 - DONE
./mole.sh secret-log -b 2020-02-02 -a 2010-01-01                #4 - DONE
./mole.sh secret-log -b 2020-02-02 directory                    #4 - DONE
./mole.sh secret-log -a 2010-01-01 directory                    #4 - DONE
./mole.sh secret-log -b 2020-02-02 -a 2010-01-01 directory      #4 - DONE