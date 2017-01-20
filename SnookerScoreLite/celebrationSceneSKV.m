//
//  celebrationSceneSKV.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 17/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "celebrationSceneSKV.h"

@implementation celebrationSceneSKV

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        
        self.backgroundColor = [SKColor clearColor];
 
        SKEmitterNode *emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MyParticle" ofType:@"sks"]];
        emitter.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height/2);
        emitter.name = @"sparks";
        emitter.targetNode = self.scene;
        //emitter2.numParticlesToEmit = 2000;
        [self addChild:emitter];

    }
    
    
    return self;
}

//particle explosion - uses MyParticle.sks
- (SKEmitterNode *) newExplosion: (float)posX : (float) posy
{
    SKEmitterNode *emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MyParticle2" ofType:@"sks"]];
    emitter.position = CGPointMake(posX,posy);
    emitter.name = @"fireflies";
    emitter.targetNode = self.scene;
    emitter.numParticlesToEmit = 1000;
    emitter.zPosition=2.0;
    return emitter;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        //add effect at touch location
        [self addChild:[self newExplosion:location.x : location.y]];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
}


@end
