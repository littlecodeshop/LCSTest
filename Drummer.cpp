/***************************************************/
/*! \class Drummer
    \brief STK drum sample player class.

    This class implements a drum sampling
    synthesizer using FileWvIn objects and one-pole
    filters.  The drum rawwave files are sampled
    at 22050 Hz, but will be appropriately
    interpolated for other sample rates.  You can
    specify the maximum polyphony (maximum number
    of simultaneous voices) via a #define in the
    Drummer.h.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2007.
*/
/***************************************************/

#include "Drummer.h"
#include <cmath>

// Not really General MIDI yet.
unsigned char genMIDIMap[128] =
{ 1,1,1,1,1,1,1,1,		// 0-7
1,1,1,1,1,1,1,1,		// 8-15
1,1,1,1,1,1,1,1,		// 16-23
1,1,1,1,1,1,1,1,		// 24-31
1,1,1,1,1,1,2,1,		// 32-39
2,3,6,3,6,4,7,4,		// 40-47
5,8,5,1,1,1,10,1,		// 48-55
9,1,1,1,1,1,1,1,		// 56-63
1,1,1,1,1,1,1,1,		// 64-71
1,1,1,1,1,1,1,1,		// 72-79
1,1,1,1,1,1,1,1,		// 80-87
1,1,1,1,1,1,1,1,		// 88-95
1,1,1,1,1,1,1,1,		// 96-103
1,1,1,1,1,1,1,1,		// 104-111
1,1,1,1,1,1,1,1,		// 112-119
1,1,1,1,1,1,1,1     // 120-127
};

char waveNames[DRUM_NUMWAVES][16] =
  { 
    "dope.ric",
    "bassdrum.ric",
    "snardrum.ric",
    "tomlowdr.ric",
    "tommiddr.ric",
    "tomhidrm.ric",
    "hihatcym.ric",
    "ridecymb.ric",
    "crashcym.ric", 
    "cowbell1.ric", 
    "tambourn.ric"
  };

Drummer :: Drummer() : Instrmnt()
{
  // This counts the number of sounding voices.
  nSounding_ = 0;
  soundOrder_ = std::vector<int> (DRUM_POLYPHONY, -1);
  soundNumber_ = std::vector<int> (DRUM_POLYPHONY, -1);
}

Drummer :: ~Drummer()
{
}

void Drummer :: noteOn(StkFloat instrument, StkFloat amplitude)
{
#if defined(_STK_DEBUG_)
  errorString_ << "Drummer::NoteOn: instrument = " << instrument << ", amplitude = " << amplitude << '.';
  handleError( StkError::DEBUG_WARNING );
#endif

  StkFloat gain = amplitude;
  if ( amplitude > 1.0f ) {
    errorString_ << "Drummer::noteOn: amplitude parameter is greater than 1.0 ... setting to 1.0!";
    handleError( StkError::WARNING );
    gain = 1.0f;
  }
  else if ( amplitude < 0.0f ) {
    errorString_ << "Drummer::noteOn: amplitude parameter is less than 0.0 ... doing nothing!";
    handleError( StkError::WARNING );
    return;
  }

  // Yes, this is tres kludgey.
  int noteNumber = (int) ( ( 12 * log( instrument / 220.0f ) / log( 2.0f ) ) + 57.01f );

  // If we already have a wave of this note number loaded, just reset
  // it.  Otherwise, look first for an unused wave or preempt the
  // oldest if already at maximum polyphony.
  int iWave;
  for ( iWave=0; iWave<DRUM_POLYPHONY; iWave++ ) {
    if ( soundNumber_[iWave] == noteNumber ) {
      if ( waves_[iWave].isFinished() ) {
        soundOrder_[iWave] = nSounding_;
        nSounding_++;
      }
      waves_[iWave].reset();
      filters_[iWave].setPole( 0.999f - (gain * 0.6f) );
      filters_[iWave].setGain( gain );
      break;
    }
  }

  if ( iWave == DRUM_POLYPHONY ) { // This note number is not currently loaded.
    if ( nSounding_ < DRUM_POLYPHONY ) {
      for ( iWave=0; iWave<DRUM_POLYPHONY; iWave++ )
        if ( soundOrder_[iWave] < 0 ) break;
      nSounding_ += 1;
    }
    else {
      for ( iWave=0; iWave<DRUM_POLYPHONY; iWave++ )
        if ( soundOrder_[iWave] == 0 ) break;
      // Re-order the list.
      for ( int j=0; j<DRUM_POLYPHONY; j++ ) {
        if ( soundOrder_[j] > soundOrder_[iWave] )
          soundOrder_[j] -= 1;
      }
    }
    soundOrder_[iWave] = nSounding_ - 1;
    soundNumber_[iWave] = noteNumber;

    // Concatenate the STK rawwave path to the rawwave file
    waves_[iWave].openFile( (Stk::rawwavePath() + waveNames[ genMIDIMap[ noteNumber ] ]).c_str(), true );
    if ( Stk::sampleRate() != 22050.0f )
      waves_[iWave].setRate( 22050.0f / Stk::sampleRate() );
    filters_[iWave].setPole( 0.999f - (gain * 0.6f) );
    filters_[iWave].setGain( gain );
  }

#if defined(_STK_DEBUG_)
  errorString_ << "Drummer::noteOn: number sounding = " << nSounding_ << '\n';
  for ( int i=0; i<nSounding_; i++ ) errorString_ << soundNumber_[i] << "  ";
  errorString_ << '\n';
  handleError( StkError::DEBUG_WARNING );
#endif
}

void Drummer :: noteOff( StkFloat amplitude )
{
  // Set all sounding wave filter gains low.
  int i = 0;
  while ( i < nSounding_ ) filters_[i++].setGain( amplitude * 0.01f );
}

StkFloat Drummer :: computeSample()
{
  lastOutput_ = 0.0f;
  if ( nSounding_ == 0 ) return lastOutput_;

  for ( int i=0; i<DRUM_POLYPHONY; i++ ) {
    if ( soundOrder_[i] >= 0 ) {
      if ( waves_[i].isFinished() ) {
        // Re-order the list.
        for ( int j=0; j<DRUM_POLYPHONY; j++ ) {
          if ( soundOrder_[j] > soundOrder_[i] )
            soundOrder_[j] -= 1;
        }
        soundOrder_[i] = -1;
        nSounding_--;
      }
      else
        lastOutput_ += filters_[i].tick( waves_[i].tick() );
    }
  }

  return lastOutput_;
}
