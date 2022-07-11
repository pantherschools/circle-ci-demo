public with sharing class QueueableDemo implements System.Queueable {

    //ID jobID = System.enqueueJob(new QueueableDemo());
    public QueueableDemo() {

    }

    public void execute(System.QueueableContext qc){
        System.debug('Calling Queueable Method****** ');
        Future1.method1();
        Future1.method2();
        Future1.method3();
        System.debug('Calling Future Method****** ');
    }

}
