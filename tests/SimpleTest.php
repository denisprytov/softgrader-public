<?php
use PHPUnit\Framework\TestCase;

final class SimpleTest extends TestCase
{
    public function testCanReplaceAmp(): void
    {
        $this->assertEquals(
            '&amp;',
            replace_amp('&')
        );
    }
}