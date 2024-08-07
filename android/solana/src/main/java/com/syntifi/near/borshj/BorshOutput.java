package com.syntifi.near.borshj;


import com.syntifi.near.borshj.annotation.BorshSubTypes;
import com.syntifi.near.borshj.exception.BorshException;
import com.syntifi.near.borshj.util.BorshUtil;

import java.lang.reflect.Field;
import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.SortedSet;

import static java.util.Objects.requireNonNull;

/**
 * Interface with default implementations for input bytes/reading data
 *
 * @param <S> the concrete class of the buffer that implements this interface
 * @author Alexandre Carvalho
 * @author Andre Bertolace
 * @since 0.1.0
 */
public interface BorshOutput<S> {
    /**
     * Writes to buffer to specified type of clazz
     *
     * @param object the object to write
     * @return the calling BorshOutput instance
     */
   
    default S write(final Object object) {
        requireNonNull(object);
        if (object instanceof Byte) {
            return this.writeU8((byte) object);
        } else if (object instanceof Short) {
            return this.writeU16((short) object);
        } else if (object instanceof Integer) {
            return this.writeU32((int) object);
        } else if (object instanceof Long) {
            return this.writeU64((long) object);
        } else if (object instanceof Float) {
            return this.writeF32((float) object);
        } else if (object instanceof Double) {
            return this.writeF64((double) object);
        } else if (object instanceof Boolean) {
            return this.writeBoolean((Boolean) object);
        } else if (object instanceof BigInteger) {
            return this.writeU128((BigInteger) object);
        } else if (object instanceof String) {
            return this.writeString((String) object);
        } else if (object instanceof List) {
            return this.writeGenericArray((List<?>) object);
        } else if (object instanceof byte[]) {
            return this.writeFixedArray((byte[]) object);
        } else if (object instanceof Optional) {
            return this.writeOptional((Optional<?>) object);
        } else if (object instanceof Map) {
            return this.writeGenericMap((Map<?, ?>) object);
        } else if (BorshUtil.hasAnnotation(object.getClass().getInterfaces(), BorshSubTypes.class)) {
            return this.writeSubType(object);
        } else if (object.getClass().isEnum()) {
            return this.writeEnum(object);
        } else if (object instanceof Borsh) {
            return this.writePOJO(object);
        }
        throw new IllegalArgumentException();
    }

    /**
     * Writes a subtype object of an interface
     *
     * @param object the object to write
     * @return the calling BorshOutput instance
     */
    default S writeSubType(Object object) {
        BorshSubTypes borshSubTypes = BorshUtil.findAnnotation(object.getClass().getInterfaces(), BorshSubTypes.class);

        Optional<BorshSubTypes.BorshSubType> useSubType = Arrays.stream(borshSubTypes.value()).filter(t -> t.use() == object.getClass()).findFirst();
        if (useSubType.isPresent()) {
            this.writeU8(useSubType.get().when());
            return this.writePOJO(object);
        } else {
            throw new BorshException("No subtype for this interface");
        }
    }

    /**
     * Writes an Enum value
     *
     * @param object the Enum value
     * @return the calling BorshOutput instance
     */
    default S writeEnum(Object object) {
        Enum<?> enumerator = (Enum<?>) object;

        return this.writeU8(enumerator.ordinal());
    }

    /**
     * Writes a Borsh POJO to buffer
     *
     * @param object the POJO object to write
     * @return the calling BorshOutput instance
     */
    @SuppressWarnings("unchecked")
   
    default S writePOJO(final Object object) {
        try {
            SortedSet<Field> fields = BorshUtil.filterAndSort(BorshUtil.getAllFields(object.getClass()));
            for (final Field field : fields) {
                field.setAccessible(true);
                this.write(field.get(object));
            }
        } catch (IllegalAccessException error) {
            throw new BorshException(error);
        }
        return (S) this;
    }

    /**
     * Writes an int as U8
     *
     * @param value the int to write
     * @return the calling BorshOutput instance
     */
   
    default S writeU8(final int value) {
        return this.writeU8((byte) value);
    }

    /**
     * Writes a byte as U8
     *
     * @param value the byte to write
     * @return the calling BorshOutput instance
     */
   
    default S writeU8(final byte value) {
        return this.write(value);
    }

    /**
     * Writes an int as U16
     *
     * @param value the int to write
     * @return the calling BorshOutput instance
     */
   
    default S writeU16(final int value) {
        return this.writeU16((short) value);
    }

    /**
     * Writes a short as U16
     *
     * @param value the short to write
     * @return the calling BorshOutput instance
     */
   
    default S writeU16(final short value) {
        return this.writeBuffer(BorshBuffer.allocate(2).writeU16(value));
    }

    /**
     * Writes an int as U32
     *
     * @param value the int to write
     * @return the calling BorshOutput instance
     */
   
    default S writeU32(final int value) {
        return this.writeBuffer(BorshBuffer.allocate(4).writeU32(value));
    }

    /**
     * Writes a long as U64
     *
     * @param value the long to write
     * @return the calling BorshOutput instance
     */
   
    default S writeU64(final long value) {
        return this.writeBuffer(BorshBuffer.allocate(8).writeU64(value));
    }

    /**
     * Writes a long as U128
     *
     * @param value the long to write
     * @return the calling BorshOutput instance
     */
   
    default S writeU128(final long value) {
        return this.writeU128(BigInteger.valueOf(value));
    }

    /**
     * Writes a BigInteger as U128
     *
     * @param value the BigInteger to write
     * @return the calling BorshOutput instance
     */
    @SuppressWarnings("unchecked")
   
    default S writeU128(final BigInteger value) {
        if (value.signum() == -1) {
            throw new ArithmeticException("integer underflow");
        }
        if (value.bitLength() > 128) {
            throw new ArithmeticException("integer overflow");
        }
        final byte[] bytes = value.toByteArray();
        for (int i = bytes.length - 1; i >= 0; i--) {
            this.write(bytes[i]);
        }
        for (int i = 0; i < 16 - bytes.length; i++) {
            this.write((byte) 0);
        }
        return (S) this;
    }

    /**
     * Writes a float as F32
     *
     * @param value the float to write
     * @return the calling BorshOutput instance
     */
   
    default S writeF32(final float value) {
        return this.writeBuffer(BorshBuffer.allocate(4).writeF32(value));
    }

    /**
     * Writes a double as F64
     *
     * @param value the double to write
     * @return the calling BorshOutput instance
     */
   
    default S writeF64(final double value) {
        return this.writeBuffer(BorshBuffer.allocate(8).writeF64(value));
    }

    /**
     * Writes a string
     *
     * @param string the string to write
     * @return the calling BorshOutput instance
     */
   
    default S writeString(final String string) {
        final byte[] bytes = string.getBytes(StandardCharsets.UTF_8);
        this.writeU32(bytes.length);
        return this.write(bytes);
    }

    /**
     * Writes a fixed array
     *
     * @param array the fixed array to write
     * @return the calling BorshOutput instance
     */
   
    default S writeFixedArray(final byte[] array) {
        return this.write(array);
    }

    /**
     * Writes an array of type T
     *
     * @param array the array of type T to write
     * @param <T>   type of array item
     * @return the calling BorshOutput instance
     */
    @SuppressWarnings("unchecked")
   
    default <T> S writeGenericArray(final T[] array) {
        this.writeU32(array.length);
        for (final T element : array) {
            this.write(element);
        }
        return (S) this;
    }

    /**
     * Writes a Collection
     *
     * @param collection the collection to write
     * @param <T>        the collection parameter type
     * @return the calling BorshOutput instance
     */
    @SuppressWarnings("unchecked")
   
    default <T> S writeGenericArray(final Collection<T> collection) {
        this.writeU32(collection.size());
        for (final T element : collection) {
            this.write(element);
        }
        return (S) this;
    }

    /**
     * Writes a Map
     *
     * @param map the map to write
     * @param <K> key parameter class
     * @param <V> value parameter class
     * @return the calling BorshOutput instance
     */
    @SuppressWarnings("unchecked")
    default <K, V> S writeGenericMap(final Map<K, V> map) {
        this.writeU32(map.size());
        for (final Map.Entry<K, V> element : map.entrySet()) {
            this.write(element.getKey());
            this.write(element.getValue());
        }
        return (S) this;
    }

    /**
     * Writes a boolean
     *
     * @param value the boolean to write
     * @return the calling BorshOutput instance
     */
   
    default S writeBoolean(final boolean value) {
        return this.writeU8(value ? 1 : 0);
    }

    /**
     * Writes a Optional
     *
     * @param optional the optional to write
     * @return the calling BorshOutput instance
     */
   
    default S writeOptional(final Optional<?> optional) {
        if (optional.isPresent()) {
            this.writeU8(1);
            return this.write(optional.get());
        } else {
            return this.writeU8(0);
        }
    }

    /**
     * Writes a BorshBuffer
     *
     * @param buffer the BorshBuffer to write
     * @return the calling BorshOutput instance
     */
   
    default S writeBuffer(final BorshBuffer buffer) {
        return this.write(buffer.toByteArray()); // TODO: optimize
    }

    /**
     * Writes a byte array
     *
     * @param bytes the bytes to write
     * @return the calling BorshOutput instance
     */
   
    S write(final byte[] bytes);

    /**
     * Writes a byte
     *
     * @param b byte to write
     * @return the calling BorshOutput instance
     */
   
    S write(final byte b);
}
