#### 2020-08-18
added edl as an alternative to context-op learning (only limited to the operators for now)  

(note. since there can be infinitely many contexts, the Vtotal term is wrapped around by tanh)

#### 2020-08-14
added negative learning to "context-out" failedOp overload

#### 2020-08-05
trace declarative chunks

#### 2020-07-29
根据basal ganglia对usable和unusable action同时的强化和负强化机制，需要增加对failed-op和context的负向学习。
因此，需要对previousOperators进行分流
